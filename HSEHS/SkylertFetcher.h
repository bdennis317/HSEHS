//
//  SkylertFetcher.h
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SkylertFetcher : NSObject {
    MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
}

@property (nonatomic, strong) NSMutableArray *skylerts;

@property (nonatomic, weak) UIViewController* delegate;

- (void)downloadSkylerts;

@end
