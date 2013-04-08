//
//  FeedParser.h
//  HSEHS
//
//  Created by Ben Dennis on 3/11/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@interface FeedParser : NSObject <MWFeedParserDelegate> 

@property (nonatomic, retain) NSURL *feedURL;

-(void)storeAllData;

@property NSMutableArray *parsedItems;
@property (nonatomic, retain) MWFeedParser *feedParser;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableArray *existingRecords;

@end
