//
//  SkylertsViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkylertsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
   
   // NSMutableArray *rowHeights;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *skylerts;
@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;


-(void)announcementFetcherDidFinishDownload:(id)sender withAnnouncements:(NSArray *)skyArray;

@end
