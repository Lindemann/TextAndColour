//
//  PhotoActionSheetView.m
//  Text&Colour
//
//  Created by Lindemann on 17.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#import "PhotoActionSheetView.h"
#import "Device.h"

/*----------------------------------------------------------------------------------------------*/

#define HEIGHT 260
#define WIDTH 320

#define HIDING_Y_IPHONE_SHORT 460
#define SHOWING_Y_IPHONE_SHORT  200

#define HIDING_Y_IPHONE_LONG 548
#define SHOWING_Y_IPHONE_LONG  200 // should be 288

/*----------------------------------------------------------------------------------------------*/

@implementation PhotoActionSheetView

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoActionSheetView" owner:self options:nil];
    self = [nib objectAtIndex:0];
    // Reset View
    self.backgroundView.alpha = 0;
    
    if ([Device resolution] == IPHONE_SHORT) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WIDTH, HEIGHT);
    }
    if ([Device resolution] == IPHONE_LONG) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WIDTH, HEIGHT);
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraButton.enabled = NO;
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
        [self.delegate cancelButtonPressed];
    }];
}

- (IBAction)openLibraryButtonPressed {
    // [self cancelButtonPressed];
    
    // Bug with Completionhandler in cancelButtonPressed
    // Bad Quick Fix
    // Same Code like in cancelButtonPressed
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
        [self.delegate cancelButtonPressed];
        
        // LOOK
        [self.delegate openLibraryForItem:self.item InTableView:self.tableView atSwipeCellIndexPath:self.swipeCellIndexPath];
        
    }];
}

- (IBAction)makeANewPhotoButtonPressed {
    // [self cancelButtonPressed];
    
    // Bug with Completionhandler in cancelButtonPressed
    // Bad Quick Fix
    // Same Code like in cancelButtonPressed
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
        [self.delegate cancelButtonPressed];
        
        // LOOK
        [self.delegate makeANewPhotoForItem:self.item InTableView:self.tableView atSwipeCellIndexPath:self.swipeCellIndexPath];
        
    }];
}

@end
