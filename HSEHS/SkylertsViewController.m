//
//  SkylertsViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "SkylertsViewController.h"
#import "SkylertFetcher.h"
#import "Skylert.h"
#import "ECSlidingViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertCell.h"

@interface SkylertsViewController ()

@end

@implementation SkylertsViewController

@synthesize skylerts, tableView, menuBtn, navBar, hudView;

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
    SkylertFetcher *fetcher = [[SkylertFetcher alloc] init];
    fetcher.delegate = self;
    [fetcher downloadSkylerts];
    skylerts = fetcher.skylerts;
    [self setUpMenuAndNav];
    
    [self addHud];
    
    //[self performSelectorOnMainThread:@selector(addHud) withObject:nil waitUntilDone:NO];
	// Do any additional setup after loading the view.
}

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
}

-(void)updateHUDProgess:(NSNumber *)progress {
    HUD.progress = [progress floatValue];
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
    
    [tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whitepattern@2x.png"]]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) skylertFetcherDidStartDownload:(id)sender {
    self.hudView.labelText = @"Downloading Alerts";
    [self.hudView show:YES];
}
-(void)announcementFetcherDidFinishDownload:(id)sender withAnnouncements:(NSArray *)skyArray {

    skylerts = [NSMutableArray arrayWithCapacity:[skyArray count]];
    NSEnumerator *enumerator = [skyArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [skylerts addObject:element];
    }
    
    [self reloadTable];
    
    //[self.hudView hide:YES];
}


- (void)skylertFetcher:(id)sender didFailWithError:(NSError *)anError {
    [self.hudView hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"We couldn't download the Alerts. Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


-(void)reloadTable {
    
    [tableView reloadData];
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
    return [skylerts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Skylert *skylert = [skylerts objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
     
        cell = [[AlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier indexPath:indexPath tableView:tableView standardHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath] alert:skylert];
        
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"The name is: %@",skylert.name);
    
    return cell;
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return ts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //create a new text view just to extract it's size.
    //Find a less expensive solutions later
    
    Skylert * lert = [skylerts objectAtIndex:indexPath.row];
    CGSize size =   [self sizeOfText:lert.message widthOfTextView:310 withFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(7,29,size.width,size.height)];
    message.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    message.text = lert.message;
    [message sizeToFit];
    
    return message.contentSize.height + 38;
}


@end
