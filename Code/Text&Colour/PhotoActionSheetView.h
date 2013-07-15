//
//  PhotoActionSheetView.h
//  Text&Colour
//
//  Created by Lindemann on 17.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

/*----------------------------------------------------------------------------------------------*/

@protocol PhotoActionSheetViewDelegate;

/*----------------------------------------------------------------------------------------------*/

@interface PhotoActionSheetView : UIView

@property (nonatomic, weak) id <PhotoActionSheetViewDelegate> delegate;
@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *swipeCellIndexPath;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;

- (IBAction)openLibraryButtonPressed;
- (IBAction)makeANewPhotoButtonPressed;
- (IBAction)cancelButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol PhotoActionSheetViewDelegate <NSObject>

@optional

- (void)cancelButtonPressed;
- (void)openLibraryForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;
- (void)makeANewPhotoForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath;

@end