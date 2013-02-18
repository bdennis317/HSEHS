//
//  VideoFetcher.h
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoFetcher : NSObject


@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, weak) id delegate;

- (void)downloadVideos;


@end
