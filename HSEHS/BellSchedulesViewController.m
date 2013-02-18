//
//  BellSchedulesViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/3/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "BellSchedulesViewController.h"
#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "Schedule.h"

@interface BellSchedulesViewController ()

@end

@implementation BellSchedulesViewController

@synthesize menuBtn, periods, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadSchedule {
    
    if (!schedule)
        schedule = [[NSMutableArray alloc] init];
        
    if (campusControl.selectedSegmentIndex == 0) {
        
        switch (typeControl.selectedSegmentIndex) {
            case 0:
           //     schedule = [NSArray arrayWithObjects:]l
                break;
                
            default:
                break;
        }
    }
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuAndNav];
    
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whitepattern@2x.png"]]];
    periods = [[NSArray alloc] initWithObjects:@"Period 1", @"Period 2", @"Period 3", @"Period 4", @"Period 5", @"Period 6", @"Period 7",  nil];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor blackColor];
   // [self set]
    
	// Do any additional setup after loading the view.
}

-(void)setScheduleForCampus:(NSString *)campus {
    
    if ([campus isEqualToString:@"Main"]) {
        
        ClassPeriod *c1 = [[ClassPeriod alloc] initWithPeriodNum:1 type:@"Reg" start:[NSDate date] end:[NSDate date]];
        
      //  NSArray *scheulde = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,c6,c7];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [periods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundView =
        [[UIImageView alloc] init];
		cell.selectedBackgroundView =
        [[UIImageView alloc] init];
        cell.textLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,300,30)];
       
        if (indexPath.row == 4) {
            timeLabel.text = @"(a: 11:30-12:01) (b: 11:30-12:01) (c: 11:30-12:01)";
             timeLabel.font = [UIFont italicSystemFontOfSize:10];
        }
        else {
            timeLabel.text = @"8:30 - 9:30";
             timeLabel.font = [UIFont italicSystemFontOfSize:16];
        }
        timeLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:timeLabel];
    }
    
    UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
    UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    ((UIImageView *)cell.selectedBackgroundView).image = selectedBackground;
    
    //  [cell setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [periods objectAtIndex:indexPath.row]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    NSLog(@"The cell height: %f", cell.frame.size.height);
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    /*
    NSString *identifier = [NSString stringWithFormat:@"%@", [periods objectAtIndex:indexPath.row]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    */
    
}

@end
