//
//  HandbookViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/1/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandbookViewController : UIViewController
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIWebView *webView;
}

@property (nonatomic,strong) UIButton *menuBtn;

@end
