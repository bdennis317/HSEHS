//
//  NewsStoryScrollView.m
//  HSEHS
//
//  Created by Ben Dennis on 2/18/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "NewsStoryScrollView.h"

@implementation NewsStoryScrollView

@synthesize title, date, image, body;

- (id)initWithFrame:(CGRect)frame title:(NSString *)_title date:(NSDate *)_date imageURL:(NSString *)_imageURL body:(NSString *)_body 
{
    
    title = _title;
    body = _body;
    //image = _imageURL;
    date = _date;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    [self setOpaque:NO];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 210, 70)];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 3;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    titleLabel.text = title;
    NSLog(@"The title is %@",title);
        [titleLabel setOpaque:YES];
        titleLabel.textColor = [UIColor blackColor];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 90, 300, 500)];
        textView.editable = NO;
    textView.text = body;
    
    [self addSubview:titleLabel];
    [self addSubview:imageView];
    [self addSubview:textView];
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
