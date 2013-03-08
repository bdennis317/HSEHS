//
//  NewsStoryScrollView.h
//  HSEHS
//
//  Created by Ben Dennis on 2/18/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsStoryScrollView : UIScrollView

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateString;


- (id)initWithFrame:(CGRect)frame title:(NSString *)_title date:(NSDate *)_date imageURL:(NSString *)_imageURL body:(NSString *)_body;

@end
