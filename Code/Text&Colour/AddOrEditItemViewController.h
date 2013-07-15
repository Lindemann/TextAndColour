//
//  AddEntryViewController.h
//  EarlyBirdToDo
//
//  Created by Judith Lindemann on 25.12.11.
//  Copyright (c) 2011 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+BugFix.h"
#import "AddOrEditItemOptionPanelView.h"
#import "ColorActionSheetView.h"
#import "PhotoActionSheetView.h"
#import "PhotoFeedbackView.h"

/*----------------------------------------------------------------------------------------------*/

typedef enum _Mode {
    ADDMODE,
    EDITMODE
} Mode;

/*----------------------------------------------------------------------------------------------*/

@interface AddOrEditItemViewController : UIViewController <UITextViewDelegate, AddOrEditItemOptionPanelViewDelegate, ColorActionSheetViewDelegate, PhotoActionSheetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoFeedbackViewProtocol>

@property (strong, nonatomic) UITextView *textView;
@property Mode mode;
@property (strong, nonatomic) Item *currentItem;
@property (strong, nonatomic) Item *parent;


@end
