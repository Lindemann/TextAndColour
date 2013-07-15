//
//  DropAndSwipeTableViewController.h
//  Text&Colour
//
//  Created by Lindemann on 29.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeTableViewCell.h"
#import "OptionPanelTableViewCell.h"
#import "ColorActionSheetView.h"
#import "DeleteItemActionSheetView.h"
#import "PhotoActionSheetView.h"
#import "AppDelegate.h"
#import "ImagePickerController.h"

@interface SuperTableViewController : UITableViewController <SwipeTableViewCellDelegate, OptionPanelTableViewCellDelegate, ColorActionSheetViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, DeleteItemActionSheetDelegate, PhotoActionSheetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) ImagePickerController *imagePickerController;

- (void)hideOptionPanelInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath;
- (void)savePhotoInDBWithInfo:(NSDictionary *)info;

@end
