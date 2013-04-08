//
//  YoutubePlayerViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "YoutubePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YoutubePlayerViewController ()

@end

@implementation YoutubePlayerViewController
@synthesize webView, navBar, url;

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
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
    
    NSArray *videoURLSplit = [url componentsSeparatedByString:@"v="];
    NSString *videoID = [[videoURLSplit objectAtIndex:1] substringToIndex:11];
    NSString* newURL = [NSString stringWithFormat:@"http://www.youtube.com/v/%@", videoID];

    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, newURL, self.view.frame.size.width, self.view.frame.size.height];
    if(webView == nil) {
        //webView = [[UIWebView alloc] initWithFrame:frame];
        //[self.view addSubview:videoView];
    }
    [webView loadHTMLString:html baseURL:nil];
    

    
   //[videoView loadHTMLString:html baseURL:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
