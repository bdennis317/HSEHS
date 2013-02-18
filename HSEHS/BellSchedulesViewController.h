//
//  BellSchedulesViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/3/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassPeriod.h"
#import "Schedule.h"

@interface BellSchedulesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UINavigationBar *navBar;
    IBOutlet UISegmentedControl *campusControl;
    IBOutlet UISegmentedControl *typeControl;
    NSMutableArray *schedule;
}


@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic,strong) NSArray *periods;
@property (nonatomic, strong) IBOutlet UITableView *tableView;


@end
