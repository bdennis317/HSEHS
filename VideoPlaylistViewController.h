//
//  VideoPlaylistViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/15/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlaylistViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
   IBOutlet UITableView *tableView;
}


@property (strong, nonatomic) NSMutableArray *videos;
@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;


-(void)announcementFetcherDidFinishDownload:(id)sender withAnnouncements:(NSArray *)vidArray;



@end
