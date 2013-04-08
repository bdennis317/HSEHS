//
//  AnnouncementCell.h
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Announcement.h"
#import "Skylert.h"

@interface AnnouncementCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView standardHeight:(int)standardHeight alert:(Announcement *)announcement;

@end






