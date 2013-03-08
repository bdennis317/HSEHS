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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundView =
        [[UIImageView alloc] init];
		cell.selectedBackgroundView =
        [[UIImageView alloc] init];
        //cell.textLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
    
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 302, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        title.adjustsFontSizeToFitWidth = YES;
        title.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = skylert.name;
        title.userInteractionEnabled = NO;
            
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(15, 26, 310,20)];
        date.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        date.adjustsFontSizeToFitWidth = YES;
        date.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.35 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        date.text = [dateFormatter stringFromDate:skylert.date];
        date.userInteractionEnabled = NO;
     
        
        
        CGSize size =   [self sizeOfText:skylert.message widthOfTextView:310 withFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(7,38,size.width,size.height)];
        message.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        message.userInteractionEnabled = NO;

        message.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.4 alpha:1.0];
              message.backgroundColor = [UIColor clearColor];
        message.text = [skylert message];
        [message sizeToFit];
        
        CGRect frame = message.frame;
        frame.size.height = message.contentSize.height;
        message.frame = frame;
        
       
        
        UIImage *rowBackground;
        UIImage *selectionBackground;
        NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
        NSInteger row = [indexPath row];
        UIView *background = [[UIView alloc] init];
        [background setBackgroundColor:[UIColor whiteColor]];
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        seperator.frame = CGRectMake(9, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 2, 302, 1);
        
        //only one row 
        if (row == 0 && row == sectionRows - 1)
        {
            background.frame = CGRectMake(9, 9, 302, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 9);
            
             [background.layer setCornerRadius:7.0f];
             [background.layer setMasksToBounds:YES];
             [background.layer setBorderWidth:0.0f];
        }
        else if (row == 0)
        {
            //top row
            
            background.frame = CGRectMake(9, 9, 302, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 9);
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            layer.path = path.CGPath;
            background.layer.mask = layer;
            

        }
        else if (row == sectionRows - 1)
        {
            //bottom row
            background.frame = CGRectMake(9, 0, 302, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 9);
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:background.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(7.0, 7.0)];
            layer.path = path.CGPath;
            background.layer.mask = layer;
            
            message.frame = CGRectMake(message.frame.origin.x,message.frame.origin.y - 6, message.frame.size.width, message.frame.size.height);
            title.frame = CGRectMake(title.frame.origin.x,title.frame.origin.y - 6, title.frame.size.width, title.frame.size.height);
            date.frame = CGRectMake(date.frame.origin.x,date.frame.origin.y - 6, date.frame.size.width, date.frame.size.height);
            [seperator setHidden:YES];
            
        }
        else
        {
            //middle row
            background.frame = CGRectMake(9, 0, 302, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            
            message.frame = CGRectMake(message.frame.origin.x,message.frame.origin.y - 6, message.frame.size.width, message.frame.size.height);
            title.frame = CGRectMake(title.frame.origin.x,title.frame.origin.y - 6, title.frame.size.width, title.frame.size.height);
            date.frame = CGRectMake(date.frame.origin.x,date.frame.origin.y - 6, date.frame.size.width, date.frame.size.height);
            
        }
        ((UIImageView *)cell.backgroundView).image = rowBackground;
        ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
        [cell addSubview:background];
        [cell addSubview:seperator];
        [cell addSubview:message];
        [cell addSubview:date];
        [cell addSubview:title];
    }
    
   // UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
   // UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
   // ((UIImageView *)cell.backgroundView).image = rowBackground;
    //((UIImageView *)cell.selectedBackgroundView).image = selectedBackground;
    
    //  [cell setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]
    
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
