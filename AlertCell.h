//
//  AlertCell.h
//  HSEHS
//
//  Created by Ben Dennis on 3/10/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Skylert.h"

@interface AlertCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView standardHeight:(int)standardHeight alert:(Skylert *)skylert;

@end
