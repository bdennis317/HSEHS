//
//  MasterAlertsViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedParser.h"

@interface MasterAlertsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UINavigationBar *navBar;
    NSMutableArray *fetchedItems;
    
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic, retain) FeedParser *feedParser;


-(void)didFinishStoringData;
-(void)dismissWebView;


@end
