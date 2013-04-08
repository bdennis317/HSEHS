//
//  Announcement.h
//  HSEHS
//
//  Created by Ben Dennis on 3/24/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MWFeedItem.h"


@interface Announcement : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * title;

- (void)setWithFeedItem:(MWFeedItem *)item;

@end
