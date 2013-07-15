//
//  DeleteActionSheet.h
//  Text&Colour
//
//  Created by Lindemann on 06.08.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>

/*----------------------------------------------------------------------------------------------*/

@protocol DeleteItemActionSheetDelegate;

/*----------------------------------------------------------------------------------------------*/


@interface DeleteItemActionSheetView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deletelButton;

@property (nonatomic, weak) id <DeleteItemActionSheetDelegate> delegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *swipeCellIndexPath;

- (IBAction)cancelButtonPressed;
- (IBAction)deleteButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol DeleteItemActionSheetDelegate <NSObject>

@optional

- (void)deletItemButtonPressedInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;

@end