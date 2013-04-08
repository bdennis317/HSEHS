//
//  Skylert.m
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "Skylert.h"
#import "StorageRoom.h"
#import "ISO8601DateFormatter.h"

@implementation Skylert

@synthesize name, message, date;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary {
    name  = NilOrValue([aDictionary objectForKey:@"name"]);
    message = NilOrValue([aDictionary objectForKey:@"message"]);
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    date = NilOrValue([formatter dateFromString:[aDictionary objectForKey:@"date"]]);
}

@end
