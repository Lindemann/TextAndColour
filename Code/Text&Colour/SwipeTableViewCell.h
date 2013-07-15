//
//  TableViewCell.h
//  TableViewCell_OptionPanel
//
//  Created by Lindemann on 19.06.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorConstants.h"
#import "SwipeButton.h"

/*----------------------------------------------------------------------------------------------*/

@protocol SwipeTableViewCellDelegate;

/*----------------------------------------------------------------------------------------------*/

@interface SwipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *reorderView;
@property (weak, nonatomic) IBOutlet UIImageView *reorderImageView;

@property (strong, nonatomic) SwipeButton *button;
@property (nonatomic, weak) UITableViewController <SwipeTableViewCellDelegate> *delegate;
@property (nonatomic) Color color;
@property (nonatomic) int count;

- (void)buttonPressed:(UIButton *)sender forEvent:(UIEvent *)event;

- (void)didSwipeRightInCell:(id)sender;
- (void)closeCell;
- (void)openCell;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol SwipeTableViewCellDelegate <NSObject>

- (void)prepareForOpenSwipeInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath;
- (void)prepareForCloseSwipeInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath;
- (void)tableView:(UITableView *)tableView didPressButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

