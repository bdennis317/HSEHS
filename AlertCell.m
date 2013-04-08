//
//  Alertself.m
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "AlertCell.h"
#import "Skylert.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlertCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView standardHeight:(int)standardHeight alert:(Skylert *)skylert {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView =
        [[UIImageView alloc] init];
		self.selectedBackgroundView =
        [[UIImageView alloc] init];
        //self.textLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
        
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 302, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        title.adjustsFontSizeToFitWidth = YES;
        title.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = skylert.name;
        title.userInteractionEnabled = NO;
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(15, 26, 310,20)];
        date.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        date.adjustsFontSizeToFitWidth = YES;
        date.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.35 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        date.text = [dateFormatter stringFromDate:skylert.date];
        date.userInteractionEnabled = NO;
        
        
        
        CGSize size =   [self sizeOfText:skylert.message widthOfTextView:310 withFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(7,38,size.width,size.height)];
        message.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        message.userInteractionEnabled = NO;
        
        message.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.4 alpha:1.0];
        message.backgroundColor = [UIColor clearColor];
        message.text = [skylert message];
        [message sizeToFit];
        
        CGRect frame = message.frame;
        frame.size.height = message.contentSize.height;
        message.frame = frame;
        
        
        
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
        }
        else if (row == 0)
        {
            //top row
            
            background.frame = CGRectMake(9, 9, 302, standardHeight- 9);
            
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
    }
    
    // UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternself@2x.png"];
    // ((UIImageView *)self.backgroundView).image = rowBackground;
    //((UIImageView *)self.selectedBackgroundView).image = selectedBackground;
    
    //  [self setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"The name is: %@",skylert.name);
    
    return self;
}


-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return ts;
}

@end
