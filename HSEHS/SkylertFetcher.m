//
//  SkylertFetcher.m
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//



#import "SkylertFetcher.h"
#import "Skylert.h"
#import "StorageRoom.h"
#import "NSObject+YAJL.h"

@interface SkylertFetcher()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation SkylertFetcher

@synthesize delegate, skylerts;
@synthesize connection, responseData;

- (void)downloadSkylerts {
    if (self.connection) {
        [self.connection cancel];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StorageRoomURL(@"/collections/5116aef60f660262330019a7/entries?preview_api=1")]];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"StorageRoomExample iPhone" forKey:@"User-Agent"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    
    [request setAllHTTPHeaderFields:headers];
    
    self.responseData = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if ([delegate respondsToSelector:@selector(announcementFetcherDidStartDownload:)]) {
        [delegate performSelector:@selector(announcementFetcherDidStartDownload:) withObject:self];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    NSLog(@"Error while downloading announcements: %@", error);
    
    if ([delegate respondsToSelector:@selector(announcementFetcher:didFailWithError:)]) {
        [delegate performSelector:@selector(announcementFetcher:didFailWithError:) withObject:self withObject:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    NSLog(@"Downloading announcements successful");
    
    NSString *content = [[NSString alloc]  initWithBytes:[self.responseData bytes] length:[self.responseData length] encoding:NSUTF8StringEncoding];
    
    @try {
        NSDictionary *json = [content yajl_JSON];
        NSDictionary *resources = (NSDictionary *)[json objectForKey:@"array"];
        NSArray *arrayOfAnnouncementDictionaries = (NSArray *)[resources objectForKey:@"resources"];
        skylerts = [NSMutableArray array];
        
        for(NSDictionary *d in arrayOfAnnouncementDictionaries) {
            Skylert *skylert = [[Skylert alloc] init];
            [skylert setWithJSONDictionary:d];
            NSLog(@"The message is %@",skylert.message);
            [skylerts addObject:skylert];
        }
        
        if ([delegate respondsToSelector:@selector(announcementFetcherDidFinishDownload:withAnnouncements:)]) {
            [delegate performSelector:@selector(announcementFetcherDidFinishDownload:withAnnouncements:) withObject:self withObject:skylerts];
        }
    }
    @catch (NSException *e) {
        NSLog(@"Error while parsing JSON and setting announcements");
        
        if ([delegate respondsToSelector:@selector(announcementFetcher:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"StorageRoomExample" code:2 userInfo:nil];
            [delegate performSelector:@selector(announcementFetcher:didFailWithError:) withObject:self withObject:error];
        }
    }
    @finally {
        content = nil;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (challenge.previousFailureCount == 0) {
        NSLog(@"Received authentication challenge");
        
        NSURLCredential *newCredential =[NSURLCredential credentialWithUser:StorageRoomAPIKey password:@"X" persistence:NSURLCredentialPersistenceForSession];
        
        [challenge.sender useCredential:newCredential forAuthenticationChallenge:challenge];
    }
    else {
        if ([delegate respondsToSelector:@selector(announcementFetcher:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"StorageRoomExample" code:3 userInfo:nil];
            [delegate performSelector:@selector(announcementFetcher:didFailWithError:) withObject:self withObject:error];
        } 
    }
}



@end
