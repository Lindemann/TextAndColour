//
//  OptionPanelTableViewCell.h
//  Text&Colour
//
//  Created by Lindemann on 11.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeTableViewCell.h"

/*----------------------------------------------------------------------------------------------*/

@protocol OptionPanelTableViewCellDelegate;

/*----------------------------------------------------------------------------------------------*/

@interface OptionPanelTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableViewController <OptionPanelTableViewCellDelegate> *delegate;
@property (nonatomic, strong) NSIndexPath *aboveCellIndexPath;

- (IBAction)colorButtonPressed;
- (IBAction)editButtonPressed;
- (IBAction)photoButtonPressed;
- (IBAction)trashButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol OptionPanelTableViewCellDelegate <NSObject>

- (void)chooseColorInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;
- (void)editItemInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;
- (void)addPhotoInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;
- (void)deleteItemInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;

@end