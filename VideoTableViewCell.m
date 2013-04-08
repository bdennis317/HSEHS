//
//  VideoTableViewCell.m
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "Video.h"
#import <QuartzCore/QuartzCore.h>



@implementation VideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView standardHeight:(int)standardHeight Video:(Video *)video
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView =
        [[UIImageView alloc] init];
		self.selectedBackgroundView =
        [[UIImageView alloc] init];
        //self.textLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
        
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(98, 7, 220, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        title.adjustsFontSizeToFitWidth = YES;
        title.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = video.title;
        title.userInteractionEnabled = NO;
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(98, 26, 220,20)];
        date.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        date.adjustsFontSizeToFitWidth = YES;
        date.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.35 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        date.text = [dateFormatter stringFromDate:video.date];
        date.userInteractionEnabled = NO;
        
        
        UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(95,38,220,100)];
        message.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        message.userInteractionEnabled = NO;
        
        message.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.4 alpha:1.0];
        message.backgroundColor = [UIColor clearColor];
        message.text = [video description];
        UIButton *playButton;
        UIWebView *webView;
        
        if (video.link) {
            
            /*
             playButton = [UIButton buttonWithType:UIButtonTypeCustom];
             playButton.frame =  CGRectMake(12, 10, 50, 50);
             [playButton setImage:[UIImage imageNamed:@"PlayButton@2x.png"]  forState:UIControlStateNormal];
             playButton.tag = indexPath.row;
             [playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
             */
            
            NSArray *videoURLSplit = [video.link componentsSeparatedByString:@"v="];
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
            width=\"80\" height=\"80\"></embed>\
            </body></html>";
            NSString* html = [NSString stringWithFormat:embedHTML, newURL, 50, 50];
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 11, 80, 80)];
            [webView loadHTMLString:html baseURL:nil];
        }
        
        
        
        UIImage *rowBackground;
        UIImage *selectionBackground;
        NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
        NSInteger row = [indexPath row];
        UIView *background = [[UIView alloc] init];
        [background setBackgroundColor:[UIColor whiteColor]];
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        seperator.frame = CGRectMake(9, standardHeight - 2, 302, 1);
        
        //only one row
        if (row == 0 && row == sectionRows - 1)
        {
            background.frame = CGRectMake(9, 9, 302, standardHeight - 9);
            
            [background.layer setCornerRadius:7.0f];
            [background.layer setMasksToBounds:YES];
            [background.layer setBorderWidth:0.0f];
            seperator.hidden = YES;
        }
        else if (row == 0)
        {
            //top row
            
            background.frame = CGRectMake(9, 9, 302, standardHeight - 9);
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            layer.path = path.CGPath;
            background.layer.mask = layer;
            
            
        }
        else if (row == sectionRows - 1)
        {
            //bottom row
            background.frame = CGRectMake(9, 0, 302, standardHeight - 9);
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            layer.path = path.CGPath;
            background.layer.mask = layer;
            
            message.frame = CGRectMake(message.frame.origin.x,message.frame.origin.y - 6, message.frame.size.width, message.frame.size.height);
            title.frame = CGRectMake(title.frame.origin.x,title.frame.origin.y - 6, title.frame.size.width, title.frame.size.height);
            date.frame = CGRectMake(date.frame.origin.x,date.frame.origin.y - 6, date.frame.size.width, date.frame.size.height);
            [seperator setHidden:YES];
            
        }
        else
        {
            //middle row
            background.frame = CGRectMake(9, 0, 302, standardHeight);
            
            message.frame = CGRectMake(message.frame.origin.x,message.frame.origin.y - 6, message.frame.size.width, message.frame.size.height);
            title.frame = CGRectMake(title.frame.origin.x,title.frame.origin.y - 6, title.frame.size.width, title.frame.size.height);
            date.frame = CGRectMake(date.frame.origin.x,date.frame.origin.y - 6, date.frame.size.width, date.frame.size.height);
        }
        
        ((UIImageView *)self.backgroundView).image = rowBackground;
        ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;
        [self addSubview:background];
        [self addSubview:seperator];
        [self addSubview:message];
        [self addSubview:date];
        [self addSubview:title];
        [self addSubview:webView];
    
    // UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // ((UIImageView *)self.backgroundView).image = rowBackground;
    //((UIImageView *)self.selectedBackgroundView).image = selectedBackground;
    
    //  [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"The title is: %@",video.title);
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
