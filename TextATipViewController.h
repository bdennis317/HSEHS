//
//  TextATipViewController.h
//  HSEHS
//
//  Created by Ben Dennis on 2/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TextATipViewController : UIViewController <MFMessageComposeViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *textButton;


- (IBAction)textTapped:(id)sender;
@end
