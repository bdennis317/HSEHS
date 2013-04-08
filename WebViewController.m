//
//  WebViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 3/24/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize menuBtn, navBar, htmlString, webView, delegate, title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuAndNav];
    webView.scalesPageToFit = YES;
    
    navBar.topItem.title = @"Announcement";
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@; padding:20px; }\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", @"helvetica", [NSNumber numberWithInt:50], htmlString];
    
    
    [webView loadHTMLString:myDescriptionHTML baseURL:nil];
	// Do any additional setup after loading the view.
}

-(void) setUpMenuAndNav {
    
  //  self.view.layer.shadowOpacity = 0.75f;
    //self.view.layer.shadowRadius = 10.0f;
    //self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    //add menu button
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 7, 47.5, 30);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"backButton@2x.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:menuBtn];
    
}

-(void)goBack:(id)sender {
    
    if ([webView canGoBack])
        [webView goBack];
    else
        [delegate performSelector:@selector(dismissWebView)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
