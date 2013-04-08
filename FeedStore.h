//
//  FeedStore.h
//  HSEHS
//
//  Created by Ben Dennis on 3/11/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedStore : NSObject

-(id)init;
-(void)storeData:(NSArray *)dataArray InEntityName:(NSString *)entityName;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
