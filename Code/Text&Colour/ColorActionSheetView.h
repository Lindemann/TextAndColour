//
//  CustomActionSheetView.h
//  CustomActionSheet
//
//  Created by Lindemann on 13.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorConstants.h"
#import "Item.h"

/*----------------------------------------------------------------------------------------------*/

@protocol ColorActionSheetViewDelegate;

/*----------------------------------------------------------------------------------------------*/

@interface ColorActionSheetView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *turquoiseButton;
@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (weak, nonatomic) IBOutlet UIButton *roseButton;
@property (weak, nonatomic) IBOutlet UIButton *coralButton;


@property (nonatomic, weak) id <ColorActionSheetViewDelegate> delegate;
@property (nonatomic, strong) Item *item;

@property (nonatomic, strong) UIImageView *feedbackImageView;


- (IBAction)cancelButtonPressed;
- (IBAction)blueButtonPressed;
- (IBAction)yellowButtonPressed;
- (IBAction)turquoiseButtonPressed;
- (IBAction)grayButtonPressed;
- (IBAction)roseButtonPressed;
- (IBAction)coralButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol ColorActionSheetViewDelegate <NSObject>

@optional

- (void)cancelButtonPressed;
- (void)blueButtonPressedForItem:(Item*)item;
- (void)yellowButtonPressedForItem:(Item*)item;
- (void)turquoiseButtonPressedForItem:(Item*)item;
- (void)grayButtonPressedForItem:(Item*)item;
- (void)roseButtonPressedForItem:(Item*)item;
- (void)coralButtonPressedForItem:(Item*)item;

@end