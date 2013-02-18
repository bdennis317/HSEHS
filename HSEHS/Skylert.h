//
//  Skylert.h
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Skylert : NSObject


@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSDate *date;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;

@end
