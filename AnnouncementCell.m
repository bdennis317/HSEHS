//
//  AnnouncementCell.m
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "Announcement.h"
#import "AnnouncementCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnnouncementCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView standardHeight:(int)standardHeight alert:(Announcement *)announcement {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView =
        [[UIImageView alloc] init];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 265, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        title.adjustsFontSizeToFitWidth = YES;
        title.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.30 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = announcement.title;
        title.userInteractionEnabled = NO;
        
        
        UIImage *rowBackground;
    
        
        NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
        NSInteger row = [indexPath row];
        UIView *background = [[UIView alloc] init];
        [background setBackgroundColor:[UIColor whiteColor]];
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        seperator.frame = CGRectMake(9, standardHeight - 2, 302, 1);
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow@2x.png"]];
        arrowImage.frame = CGRectMake(280, 9, 26, 26);
        
        UIView *selectionBackground = [[UIView alloc] init];
        
        //only one row
        if (row == 0 && row == sectionRows - 1)
        {
            background.frame = CGRectMake(9, 9, 302, standardHeight - 9);
            [background.layer setCornerRadius:7.0f];
            [background.layer setMasksToBounds:YES];
            [background.layer setBorderWidth:0.0f];
        }
        else if (row == 0)
        {
            //top row
            
            background.frame = CGRectMake(9, 9, 302, standardHeight);
            title.frame = CGRectMake(title.frame.origin.x ,title.frame.origin.y + 9, title.frame.size.width, title.frame.size.height);
            arrowImage.frame = CGRectMake(arrowImage.frame.origin.x, 18,  arrowImage.frame.size.width,  arrowImage.frame.size.width);
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            seperator.frame = CGRectMake(9, standardHeight + 9, 302, 1);
            layer.path = path.CGPath;
            background.layer.mask = layer;
          
        }
        
        else if (row == sectionRows - 1)
        {
            //bottom row
            background.frame = CGRectMake(9, 0, 302, standardHeight);
                
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            layer.path = path.CGPath;
            background.layer.mask = layer;
    
        
            title.frame = CGRectMake(title.frame.origin.x,title.frame.origin.y, title.frame.size.width, title.frame.size.height);
            seperator.hidden = YES;

            
        }
        else
        {
            //middle row
            background.frame = CGRectMake(9, 0, 302, standardHeight);
            title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, title.frame.size.height);
          
            
        }
        ((UIImageView *)self.backgroundView).image = rowBackground;
        
        [self addSubview:background];
        [self addSubview:seperator];
        [self addSubview:arrowImage];
        [self addSubview:title];
        
    }
    
    // UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // ((UIImageView *)self.backgroundView).image = rowBackground;
    //((UIImageView *)self.selectedBackgroundView).image = selectedBackground;
    
    //  [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView sizeToFit];
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return ts;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(highlighted) {
        self.backgroundColor = [UIColor blueColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

@end
