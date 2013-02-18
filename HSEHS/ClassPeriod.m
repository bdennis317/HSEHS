//
//  ClassPeriod.m
//  HSEHS
//
//  Created by Ben Dennis on 2/6/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "ClassPeriod.h"

@implementation ClassPeriod

@synthesize periodNum, type, statTime, endTime;


- (id)initWithPeriodNum:(int)p type:(NSString *)t start:(NSDate *)s end:(NSDate *)e {
    self = [super init];
    if (self) {
        periodNum = p;
        type = t;
        statTime = s;
        endTime = e;
    }
    return self;
}




@end
