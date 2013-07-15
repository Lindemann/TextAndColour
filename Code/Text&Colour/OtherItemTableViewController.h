//
//  OtherItemTableViewController.h
//  Text&Colour
//
//  Created by Judith Lindemann on 10.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstItemTableViewController.h"
#import "Item+BugFix.h"
#import "SuperTableViewController.h"
#import "NavigationScrollView.h"
#import "DeleteItemActionSheetView.h"
#import "PhotoActionSheetView.h"
#import "PhotoButton.h"

@interface OtherItemTableViewController : SuperTableViewController <NavigationScrollViewProtocol, DeleteItemActionSheetDelegate, PhotoActionSheetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoButtonDelegate>

@property (nonatomic, strong) Item *parent;

- (void)updateItems;

@end
