//
//  NewsViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/18/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface NewsViewController : UIViewController <MWFeedParserDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) MWFeedParser * feedParser;
@property (strong, nonatomic) NSMutableArray *parsedItems;
@property (strong, nonatomic) UIScrollView *scrollView;

@end
