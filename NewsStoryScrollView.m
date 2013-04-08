//
//  NewsStoryScrollView.m
//  HSEHS
//
//  Created by Ben Dennis on 2/18/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "NewsStoryScrollView.h"

@implementation NewsStoryScrollView

@synthesize title, date, image, body, imageURL, dateString;

- (id)initWithFrame:(CGRect)frame title:(NSString *)_title date:(NSDate *)_date imageURL:(NSString *)_imageURL body:(NSString *)_body 
{
    
    title = _title;
    body = _body;
    image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
    imageURL = _imageURL;
    date = _date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    dateString = [dateFormatter stringFromDate:_date];
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    [self setOpaque:NO];
        

        
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
        
        
        
      
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"NewsStoryHtml" ofType:@"html"];
        
        NSString *webViewHTML = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
        
        //if there is no image, then delete the image placeholder, if there is an image, then add it to the html
        if ([imageURL isEqualToString:@""] || !imageURL) {
            webViewHTML = [webViewHTML stringByReplacingOccurrencesOfString:@"imagehere" withString:@""];
        } else {
            NSString * imageHTMLString = [NSString stringWithFormat:@"<img src =\"%@\">",imageURL];
            webViewHTML = [webViewHTML stringByReplacingOccurrencesOfString:@"imagehere" withString:imageHTMLString];
        }
        
        webViewHTML =  [webViewHTML stringByReplacingOccurrencesOfString:@"titlehere" withString:title];
        webViewHTML =  [webViewHTML stringByReplacingOccurrencesOfString:@"datehere" withString:dateString];
        webViewHTML =  [webViewHTML stringByReplacingOccurrencesOfString:@"bodyhere" withString:body];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 10, 300, screenHeight - 87)];
    [webView loadHTMLString:webViewHTML baseURL:[NSURL URLWithString:@""]];
    

    [self addSubview:webView];
        
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
