//
//  SkylertsViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "VideoPlaylistViewController.h"
#import <CoreData/CoreData.h>
#import "VideoFetcher.h"
#import "Video.h"
#import "MBProgressHUD.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "YoutubePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "VideoTableViewCell.h"

#import "DataFetcher.h"

@interface VideoPlaylistViewController ()

@end

@implementation VideoPlaylistViewController
@synthesize videos, menuBtn, navBar;
@synthesize fetchedResultsController;
@synthesize gestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // VideoFetcher *fetcher = [[VideoFetcher alloc] init];
    VideoFetcher *fetcher = [[VideoFetcher alloc] init];
    
    fetcher.delegate = self;
    [fetcher downloadVideos];
    videos = fetcher.videos;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
   // self.refreshControl = refreshControl;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
    
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whitepattern@2x.png"]]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
   // [self addHud];
    
   // self.tableView.userInteractionEnabled = YES;
	// Do any additional setup after loading the view.
}

/*
- (void)loadRestaurants {
    NSManagedObjectContext *context = [self applicationDelegate].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"YoutubeVideos" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    fetchRequest.sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [NSFetchedResultsController deleteCacheWithName:@"YoutubeVideos"];
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"restaurants"];
    fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![fetchedResultsController performFetch:&error]) {
        [self showAlertWithMessage:@"Could not load Restaurants"];
    }
    
    NSArray *restaurants = fetchedResultsController.fetchedObjects;
    
}

*/

#pragma HUD Delegate Methods

-(void)addHud {
    
   	// The hud will dispable all input on the window
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeDeterminate;
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
    HUD.userInteractionEnabled = NO;
	HUD.labelText = @"Connecting to HSE";
    
    [HUD show:YES];
    
}


-(void)HUDFinished {
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"Connected";
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:.7];
    [HUD removeFromSuperViewOnHide];
}

-(void)updateHUDProgess:(NSNumber *)progress {
    HUD.progress = [progress floatValue];
}


-(void)announcementFetcherDidFinishDownload:(id)sender withAnnouncements:(NSArray *)vidArray {
    
    videos = [NSMutableArray arrayWithCapacity:[vidArray count]];
    NSEnumerator *enumerator = [vidArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [videos addObject:element];
    }
    
    [self reloadTable];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


-(void)reloadTable {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Video *video = [videos objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier indexPath:indexPath tableView:tableView standardHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath] Video:video];
    }
        
    return cell;
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return ts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



-(void)playVideo:(UIButton *)sender {
    
    Video *vid = [videos objectAtIndex:sender.tag];    
    
    YoutubePlayerViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YoutubePlayer"];
    viewController.url = vid.link;
    [self presentModalViewController:viewController animated:YES];

}

@end
