//
//  NewsViewController.m
//  HSEHS
//
//  Created by Ben Dennis on 2/18/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "NewsViewController.h"
#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "MWFeedParser.h"
#import "UIDevice+Resolutions.h"
#import "NewsStoryScrollView.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize navBar, menuBtn, feedParser, parsedItems, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuAndNav];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whitepattern@2x.png"]]];
    
    parsedItems = [[NSMutableArray alloc] initWithCapacity:5000];
    
    // Parse
	NSURL *feedURL = [NSURL URLWithString:@"http://www.hseorb.com/feed/"];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateViewWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                         message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
        [alert show];
    }
  [self updateViewWithParsedItems];
}

-(void)updateViewWithParsedItems {
    
    if (!scrollView) {
        
        int valueDevice = [UIDevice currentResolution];
        
        NSLog(@"valueDevice: %d ...", valueDevice);
        
 
        if (valueDevice == 3) {
            //is an iPhone 5
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, 57, 299, 400)];

        } else {
            // is before iPhone 5
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, 57, 299, 300)];
            
        }

    
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width *[parsedItems count], scrollView.bounds.size.height);
        scrollView.pagingEnabled = YES;
        NSLog(@"%d",[parsedItems count]);
        
        for (int x = 0; x < [parsedItems count]; x++) {            
            MWFeedItem *parsedStory = [parsedItems objectAtIndex:x];
            NSLog(@"The first enclosed thing: %@" ,[parsedStory.enclosures objectAtIndex:0]);
            NSLog(@"The parsed story title: %@" ,parsedStory.title);
            
            NewsStoryScrollView* storyView = [[NewsStoryScrollView alloc] initWithFrame:CGRectMake(x * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height) title:parsedStory.title    date:parsedStory.date imageURL:nil body:parsedStory.content];
            storyView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height);
          
            [scrollView addSubview:storyView];
        }
        
        [self.view addSubview:scrollView];
    }
}


@end
