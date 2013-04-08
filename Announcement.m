//
//  Announcement.m
//  HSEHS
//
//  Created by Ben Dennis on 3/24/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "Announcement.h"


@implementation Announcement

@dynamic desc;
@dynamic link;
@dynamic pubDate;
@dynamic title;



- (void)setWithFeedItem:(MWFeedItem *)item {
    
    [self setTitle:item.title];
    
    //self.title = item.title;
    //self.pubDate = item.date;
    //self.desc = item.description;
    //self.link = item.link;
}

@end
