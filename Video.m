//
//  Video.m
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "Video.h"
#import "StorageRoom.h"
#import "ISO8601DateFormatter.h"

@implementation Video

@synthesize title, link, description, date;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary {
    
    title  = NilOrValue([aDictionary objectForKey:@"title"]);
    description = NilOrValue([aDictionary objectForKey:@"desc"]);
    link = NilOrValue([aDictionary objectForKey:@"video"]);
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    date = NilOrValue([formatter dateFromString:[aDictionary objectForKey:@"time"]]);
    
}

@end
