//
//  AddOptionPanel.h
//  Text&Colour
//
//  Created by Lindemann on 12.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

/*----------------------------------------------------------------------------------------------*/

@protocol AddOrEditItemOptionPanelViewDelegate;

/*----------------------------------------------------------------------------------------------*/

@interface AddOrEditItemOptionPanelView : UIView

@property (nonatomic, weak) UIViewController <AddOrEditItemOptionPanelViewDelegate> *delegate;

- (IBAction)chooseColorButtonPressed;
- (IBAction)addPhotoButtonPressed;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol AddOrEditItemOptionPanelViewDelegate <NSObject>

- (void)chooseColorForItem;
- (void)addPhotoForItem;


@end