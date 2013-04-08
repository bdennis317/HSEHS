//
//  VideoPlaylistViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"

@interface VideoPlaylistViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
   // IBOutlet UITableView *tableView;
    MBProgressHUD *HUD;
}


@property (strong, nonatomic) NSMutableArray *videos;
@property (nonatomic,strong) IBOutlet UIButton *menuBtn;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) IBOutlet UIGestureRecognizer *gestureRecognizer;


- (void)bringSubviewToFront:(UIView *)view;
-(void)announcementFetcherDidFinishDownload:(id)sender withAnnouncements:(NSArray *)vidArray;



@end
