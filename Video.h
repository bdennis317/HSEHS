//
//  Video.h
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *link;
@property (strong, nonatomic) NSString *description;
@property (strong,nonatomic) NSDate *date;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;

@end
