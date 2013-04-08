//
//  MenuViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/1/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController {
    UITableView *tableView;
    NSArray *menuIcons;
}


@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menu;


@end
