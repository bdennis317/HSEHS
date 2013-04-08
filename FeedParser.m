//
//  FeedParser.m
//  HSEHS
//
//  Created by Ben Dennis on 3/11/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "FeedParser.h"
#import "MWFeedParser.h"
#import "FeedStore.h"
#import "Announcement.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"

@implementation FeedParser

@synthesize parsedItems, feedParser, feedURL, delegate, managedObjectContext, existingRecords;

-(void)storeAllData {
    [self getAnnouncments];
}

-(void)getAnnouncments {
    
    if (!parsedItems) {
        parsedItems = [[NSMutableArray alloc] initWithCapacity:5000];
    } else  {
        [parsedItems removeAllObjects];
    }
    
        // Parse
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        MWFeedParser * feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
        feedParser.connectionType = ConnectionTypeAsynchronously;
        [feedParser parse];
}

-(void)storeParsedAnnouncments {
    [self storeData:parsedItems InEntityName:@"Announcment"];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) { [parsedItems addObject:item];  }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self storeParsedAnnouncments];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        
    
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)storeData:(NSArray *)dataArray InEntityName:(NSString *)entityName {
    
    NSLog(@"Data array: %@", dataArray);

    if ([entityName isEqualToString:@"Announcment"]) {
        for (MWFeedItem *item  in dataArray) {
            [self storeAnnouncement:item];
        }
        if (managedObjectContext) {
            NSError *error = nil;
            [managedObjectContext save:&error];
           // NSLog(error);
        }
        
        
        if ([delegate respondsToSelector:@selector(didFinishStoringData)]) {
            [delegate performSelector:@selector(didFinishStoringData)];
        }
    }
}

-(void)storeAnnouncement:(MWFeedItem *)item {
    
    if (managedObjectContext == nil)
    {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    
    if (![self recordAlreadyExists:item.title andDate:item.date]) {
        
    //Create a new core data object
    Announcement *savedAnnouncement = (Announcement *)[NSEntityDescription insertNewObjectForEntityForName:@"Announcement" inManagedObjectContext:managedObjectContext];
    [savedAnnouncement setTitle:item.title];
    [savedAnnouncement setPubDate:item.date];
    [savedAnnouncement setDesc:item.summary];
    [savedAnnouncement setLink:item.link];
    } else {
        NSLog(@"That record already exists");
    }
}

-(BOOL)recordAlreadyExists:(NSString *)title andDate:(NSDate *)date {
    
    if (!existingRecords) {
        existingRecords = [CoreDataHelper getObjectsForEntity:@"Announcement"     withSortKey:nil andSortAscending:YES  andContext:nil];
    }
    
    if ([[existingRecords valueForKey:@"title"] containsObject:title] && [[existingRecords valueForKey:@"pubDate"] containsObject:date]) {
        return YES;
    } else {
        return NO;
    }
    
}


@end
