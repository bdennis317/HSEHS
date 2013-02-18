//
//  ClassPeriod.h
//  HSEHS
//
//  Created by Ben Dennis on 2/6/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassPeriod : NSObject

@property int periodNum;
@property NSString* type;
@property NSDate *statTime;
@property NSDate *endTime;

- (id)initWithPeriodNum:(int)p type:(NSString *)t start:(NSDate *)s end:(NSDate *)e;

@end
