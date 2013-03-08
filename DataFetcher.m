//
//  DataFetcher.m
//  HSEHS
//
//  Created by Ben Dennis on 3/8/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//


#import "DataFetcher.h"
#import "StorageRoom.h"

#import "YoutubeVideo.h"
#import "NewsStory.h"

#import "NSObject+YAJL.h"


@interface DataFetcher ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;


@end

@implementation DataFetcher

@synthesize managedObjectContext, entityType, requestURL;
@synthesize delegate;
@synthesize connection, responseData;

#pragma mark -
#pragma mark NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext {
    if (self = [super init]) {
        self.managedObjectContext = aManagedObjectContext;
    }
    
    return self;
}

- (void)setDataType:(NSString *)dataType {
    
    if ([dataType isEqualToString:@"YoutubeVideo"]) {
        requestURL = [NSURL URLWithString:StorageRoomURL(@"/collections/4d960916ba05617333000005/entries?per_page=100")];
    } else if ([dataType isEqualToString:@"NewsStory"]) {
        requestURL = [NSURL URLWithString:StorageRoomURL(@"/collections/4d960916ba05617333000005/entries?per_page=100")];
    }
    
}

- (void)dealloc {
    self.delegate = nil;
    
    [self.connection cancel];
    
}

#pragma mark -
#pragma mark Helpers

- (void)downloadData {
    if (self.connection) {
        [self.connection cancel];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"StorageRoomExample iPhone" forKey:@"User-Agent"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    
    [request setAllHTTPHeaderFields:headers];
    
    self.responseData = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if ([delegate respondsToSelector:@selector(DataFetcherDidStartDownload:)]) {
        [delegate performSelector:@selector(DataFetcherDidStartDownload:) withObject:self];
    }
}

- (void)removeAllDataFromManagedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:managedObjectContext];
	
	NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
    NSLog(@"Removing %d existing Data", [results count]);
    
    
	for (id data in results) {
		[managedObjectContext deleteObject:data];
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
    NSLog(@"Error while downloading Data: %@", error);
    
    if ([delegate respondsToSelector:@selector(DataFetcher:didFailWithError:)]) {
        [delegate performSelector:@selector(DataFetcher:didFailWithError:) withObject:self withObject:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    NSLog(@"Downloading Data successful");
    
    NSString *content = [[NSString alloc]  initWithBytes:[self.responseData bytes] length:[self.responseData length] encoding:NSUTF8StringEncoding];
    
    @try {
        NSDictionary *json = [content yajl_JSON];
        NSDictionary *resources = (NSDictionary *)[json objectForKey:@"array"];
        NSArray *arrayOfDataDictionaries = (NSArray *)[resources objectForKey:@"resources"];
        
        [self removeAllDataFromManagedObjectContext];

        
        ///
        ///Pick which data model we are going to use
        
        
        if ([entityType isEqualToString:@"YoutubeVideo"]) {
            for(NSDictionary *d in arrayOfDataDictionaries) {
                YoutubeVideo *video = (YoutubeVideo *)[NSEntityDescription insertNewObjectForEntityForName:@"YoutubeVideo" inManagedObjectContext:managedObjectContext];
                [video setWithJSONDictionary:d];
            }
        } else if ([entityType isEqualToString:@"NewsStory"]) {
            for(NSDictionary *d in arrayOfDataDictionaries) {
                NewsStory *newsStory = (NewsStory *)[NSEntityDescription insertNewObjectForEntityForName:@"NewsStory" inManagedObjectContext:managedObjectContext];
                [newsStory setWithJSONDictionary:d];
            }
        }
        
        
        
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        if ([delegate respondsToSelector:@selector(DataFetcherDidFinishDownload:)]) {
            [delegate performSelector:@selector(DataFetcherDidFinishDownload:) withObject:self];
        }
    }
    @catch (NSException *e) {
        NSLog(@"Error while parsing JSON and setting Data");
        
        if ([delegate respondsToSelector:@selector(DataFetcher:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"StorageRoomExample" code:2 userInfo:nil];
            [delegate performSelector:@selector(DataFetcher:didFailWithError:) withObject:self withObject:error];
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
        if ([delegate respondsToSelector:@selector(DataFetcher:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"StorageRoomExample" code:3 userInfo:nil];
            [delegate performSelector:@selector(DataFetcher:didFailWithError:) withObject:self withObject:error];
        } 
    }
}


@end
