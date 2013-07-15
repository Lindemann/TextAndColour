//
//  DeleteActionSheet.h
//  Text&Colour
//
//  Created by Lindemann on 06.08.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>

/*----------------------------------------------------------------------------------------------*/

@protocol DeletePhotoActionSheetDelegate;

/*----------------------------------------------------------------------------------------------*/


@interface DeletePhotoActionSheetView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deletelButton;

@property (nonatomic, weak) id <DeletePhotoActionSheetDelegate> delegate;

- (IBAction)cancelButtonPressed;
- (IBAction)deleteButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol DeletePhotoActionSheetDelegate <NSObject>

@optional

- (void)deletPhotoButtonPressed;
- (void)dismissHostController;

@end