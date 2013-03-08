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
        
    
    NSString *webViewHTML = [NSString stringWithFormat:@"<div style = \" font-family:font-family: \"HelveticaNeueBold\", \"HelveticaNeue-Bold\", \"Helvetica Neue Bold\", \"HelveticaNeue\", \"Helvetica Neue\", 'TeXGyreHerosBold', \"Helvetica\", \"Tahoma\", \"Geneva\", \"Arial\", sans-serif; font-weight:600; font-stretch:normal; font-size:15; \"> %@</div> <img style = \"float: right; margin: 4px; max-width:150px\" src =\"%@\"> <div style = \"font:Georgia,\"Times New Roman\",Times,serif;color:#999;\">%@</div>  <p> %@ </p>",title, imageURL, dateString, body];
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
