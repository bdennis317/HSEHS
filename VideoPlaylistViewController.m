//
//  SkylertsViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/9/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "VideoPlaylistViewController.h"
#import "VideoFetcher.h"
#import "Video.h"
#import "MBProgressHUD.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "YoutubePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface VideoPlaylistViewController ()

@end

@implementation VideoPlaylistViewController
@synthesize videos, menuBtn, navBar;

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
    VideoFetcher *fetcher = [[VideoFetcher alloc] init];
    fetcher.delegate = self;
    [fetcher downloadVideos];
    videos = fetcher.videos;
    [self setUpMenuAndNav];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
    [self addHud];
    
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
    return [videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = [videos objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundView =
        [[UIImageView alloc] init];
		cell.selectedBackgroundView =
        [[UIImageView alloc] init];
        //cell.textLabel.textColor = [UIColor colorWithRed:206 green:217 blue:228 alpha:1];
        
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(98, 7, 220, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        title.adjustsFontSizeToFitWidth = YES;
        title.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = video.title;
        title.userInteractionEnabled = NO;
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(98, 26, 220,20)];
        date.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        date.adjustsFontSizeToFitWidth = YES;
        date.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.35 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        date.text = [dateFormatter stringFromDate:video.date];
        date.userInteractionEnabled = NO;
        
        
        UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(95,38,220,100)];
        message.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        message.userInteractionEnabled = NO;
        
        message.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.4 alpha:1.0];
        message.backgroundColor = [UIColor clearColor];
        message.text = [video description];
        UIButton *playButton;
        UIWebView *webView;
        
        if (video.link) {
            
            /*
            playButton = [UIButton buttonWithType:UIButtonTypeCustom];
            playButton.frame =  CGRectMake(12, 10, 50, 50);
            [playButton setImage:[UIImage imageNamed:@"PlayButton@2x.png"]  forState:UIControlStateNormal];
            playButton.tag = indexPath.row;
            [playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
             */
            
            NSArray *videoURLSplit = [video.link componentsSeparatedByString:@"v="];
            NSString *videoID = [[videoURLSplit objectAtIndex:1] substringToIndex:11];
            NSString* newURL = [NSString stringWithFormat:@"http://www.youtube.com/v/%@", videoID];
            
            
            NSString* embedHTML = @"\
            <html><head>\
            <style type=\"text/css\">\
            body {\
            background-color: transparent;\
            color: white;\
            }\
            </style>\
            </head><body style=\"margin:0\">\
            <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
            width=\"80\" height=\"80\"></embed>\
            </body></html>";
            NSString* html = [NSString stringWithFormat:embedHTML, newURL, 50, 50];
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 11, 80, 80)];
             [webView loadHTMLString:html baseURL:nil];
            }
           
        
        
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
            seperator.hidden = YES;
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
        [cell addSubview:webView];
    }
    
    // UIImage* rowBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
    // UIImage* selectedBackground = [UIImage imageNamed:@"TableViewPatternCell@2x.png"];
    // ((UIImageView *)cell.backgroundView).image = rowBackground;
    //((UIImageView *)cell.selectedBackgroundView).image = selectedBackground;
    
    //  [cell setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"categorytab1.png"]]]
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"The title is: %@",video.title);
    
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
