//
//  AddOptionPanel.m
//  Text&Colour
//
//  Created by Lindemann on 12.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "AddOrEditItemOptionPanelView.h"
#import "AddOrEditItemViewController.h"

@implementation AddOrEditItemOptionPanelView

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddOrEditItemOptionPanelView" owner:self options:nil];
    self = [nib objectAtIndex:0];
    return self;
}

- (IBAction)chooseColorButtonPressed {
    [self.delegate chooseColorForItem];
}

- (IBAction)addPhotoButtonPressed {
    [self.delegate addPhotoForItem];
}

@end
