//
//  DeleteActionSheet.m
//  Text&Colour
//
//  Created by Lindemann on 06.08.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#import "DeletePhotoActionSheetView.h"
#import "Device.h"

/*----------------------------------------------------------------------------------------------*/

#define HEIGHT 200
#define WIDTH 320

#define HIDING_Y_IPHONE_SHORT 460
#define SHOWING_Y_IPHONE_SHORT  265

#define HIDING_Y_IPHONE_LONG 548
#define SHOWING_Y_IPHONE_LONG  265 // should be 260+88...

/*----------------------------------------------------------------------------------------------*/

@implementation DeletePhotoActionSheetView

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DeletePhotoActionSheetView" owner:self options:nil];
    self = [nib objectAtIndex:0];
    // Reset View
    self.backgroundView.alpha = 0;
    
    if ([Device resolution] == IPHONE_SHORT) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WIDTH, HEIGHT);
    }
    if ([Device resolution] == IPHONE_LONG) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WIDTH, HEIGHT);
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.4 animations:^{
        // Fade Background in
        self.backgroundView.alpha = 0.7;
        
        // Slide ActionSheet in
        if ([Device resolution] == IPHONE_SHORT) {
            self.actionSheetView.frame = CGRectMake(0, SHOWING_Y_IPHONE_SHORT, WIDTH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, SHOWING_Y_IPHONE_LONG, WIDTH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
    }];
    return self;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           BUTTONS                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (IBAction)cancelButtonPressed {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.4 animations:^{
        // Fade Background out
        self.backgroundView.alpha = 0;
        
        // Slide ActionSheet out
        if ([Device resolution] == IPHONE_SHORT) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WIDTH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WIDTH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
    
- (IBAction)deleteButtonPressed {
    
    [self.delegate deletPhotoButtonPressed];
    
    // Dissmiss Actionsheet
    // Copy of - (IBAction)cancelButtonPressed
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.4 animations:^{
        // Fade Background out
        self.backgroundView.alpha = 0;
        
        // Slide ActionSheet out
        if ([Device resolution] == IPHONE_SHORT) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WIDTH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WIDTH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        // Dismiss PageViewController
        [self.delegate dismissHostController];
    }];
}

@end
