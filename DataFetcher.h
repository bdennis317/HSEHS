//
//  DataFetcher.h
//  HSEHS
//
//  Created by Ben Dennis on 3/8/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject {
    
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

//The entity type must be set before the class will be able to download any data
@property (nonatomic, strong) NSString *entityType;

@property (nonatomic, strong) NSURL * requestURL;


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext;



- (void)downloadData;
- (void)removeAllRestaurantsFromManagedObjectContext;


@end
