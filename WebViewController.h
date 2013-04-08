//
//  WebViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 3/24/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic,strong) NSString *htmlString;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) id delegate;
@property (nonatomic, copy) NSString *title;



@end
