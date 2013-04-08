//
//  MasterAlertsViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "MasterAlertsViewController.h"
#import "CoreDataHelper.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "FeedParser.h"
#import "AnnouncementCell.h"
#import "Announcement.h"
#import "WebViewController.h"

@interface MasterAlertsViewController ()

@end

@implementation MasterAlertsViewController

@synthesize tableView, menuBtn, feedParser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)downloadAllData {
    
    feedParser = [[FeedParser alloc] init];
    feedParser.delegate = self;
    feedParser.feedURL = [NSURL URLWithString:@"http://www.hse.k12.in.us/feeds/announcements.ashx?school=HHS"];
    [feedParser storeAllData];

}

-(void)didFinishStoringData {
    [self fetchFromDataBase];
}

-(void)fetchFromDataBase {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    if (managedObjectContext == nil)
        NSLog(@"It's NIL!!");
    
    NSMutableArray *ar = [CoreDataHelper getObjectsForEntity:@"Announcement" withSortKey:nil andSortAscending:YES andContext:nil];
    
    
    if (!fetchedItems) {
        fetchedItems = [[NSMutableArray alloc] init];
    }
    
    //loop through the fteched data and only add the data to the local array if it does alrady exist locally 
    for (Announcement *item in ar) {
        if (![[fetchedItems valueForKey:@"title"] containsObject:item.title]) {
            [fetchedItems addObject:item];
        }
    }
    
    
    NSLog(@"Fetched Items array: %@", fetchedItems);
    [tableView reloadData];
    

   // NSLog(@"This is the stuff in the array %@", fetchedItems);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuAndNav];
    
    [tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whitepattern@2x.png"]]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //fills the table with the data that is already in the database
    [self fetchFromDataBase];
    
    //downloads new data and then calls fetch again to re-fill the table with the new data
    [self downloadAllData];
}

-(void) setUpMenuAndNav {
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //add menu button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 7, 47.5, 30);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:menuBtn];
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return 53;
    else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:1] - 1)
        return 53;
    else
        return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [fetchedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = [fetchedItems objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %d,  %d", indexPath.row, indexPath.section]; //this is where each cell gets  uniquie identifier which prevents any problems
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if ([item isKindOfClass:NSClassFromString(@"Announcement")]) {
            NSLog(@"Announcment");
            cell = [[AnnouncementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath tableView:_tableView standardHeight:44  alert:item];
            NSLog(@" Cell frame: %f", cell.frame.size.height);

        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    WebViewController*  vc = [storyboard instantiateViewControllerWithIdentifier:@"webViewController"];
    vc.delegate = self;
    vc.htmlString = [[fetchedItems objectAtIndex:indexPath.row] desc];
    vc.title = [[fetchedItems objectAtIndex:indexPath.row] title];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)dismissWebView {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
