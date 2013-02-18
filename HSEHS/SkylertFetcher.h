//
//  SkylertFetcher.h
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkylertFetcher : NSObject {
    
}

@property (nonatomic, strong) NSMutableArray *skylerts;

@property (nonatomic, weak) id delegate;

- (void)downloadSkylerts;

@end
