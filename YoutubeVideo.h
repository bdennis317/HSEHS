//
//  YoutubeVideo.h
//  HSEHS
//
//  Created by Ben Dennis on 3/8/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YoutubeVideo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * date;


- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;


@end
