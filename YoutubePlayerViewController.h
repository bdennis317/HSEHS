//
//  YoutubePlayerViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubePlayerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@end
