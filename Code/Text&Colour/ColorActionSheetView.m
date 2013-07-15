//
//  CustomActionSheetView.m
//  CustomActionSheet
//
//  Created by Lindemann on 13.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#import "ColorActionSheetView.h"
#import "Device.h"

/*----------------------------------------------------------------------------------------------*/

#define WITDH 320
#define HEIGHT 260

#define HIDING_Y_IPHONE_SHORT 460
#define SHOWING_Y_IPHONE_SHORT 200

#define HIDING_Y_IPHONE_LONG 548
#define SHOWING_Y_IPHONE_LONG 200 // is not 288...For some reason

/*----------------------------------------------------------------------------------------------*/

@implementation ColorActionSheetView

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ColorActionSheetView" owner:self options:nil];
    self = [nib objectAtIndex:0];
    // Reset View
    self.backgroundView.alpha = 0;
    
    if ([Device resolution] == IPHONE_SHORT) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WITDH, HEIGHT);
    }
    if ([Device resolution] == IPHONE_LONG) {
        self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WITDH, HEIGHT);
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.4 animations:^{
        // Fade Background in
        self.backgroundView.alpha = 0.7;
        
        // Slide ActionSheet in
        if ([Device resolution] == IPHONE_SHORT) {
            self.actionSheetView.frame = CGRectMake(0, SHOWING_Y_IPHONE_SHORT, WITDH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, SHOWING_Y_IPHONE_LONG, WITDH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
    }];
    return self;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            SETTER                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)setItem:(Item *)item {
    switch (item.color) {
        case BLUE:
            [self highlightButton:self.blueButton];
            break;
        case YELLOW:
            [self highlightButton:self.yellowButton];
            break;
        case TURQUOISE:
            [self highlightButton:self.turquoiseButton];
            break;
        case GRAY:
            [self highlightButton:self.grayButton];
            break;
        case ROSE:
            [self highlightButton:self.roseButton];
            break;
        case CORAL:
            [self highlightButton:self.coralButton];
            break;
        default:
            break;
    }
    _item = item;
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
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WITDH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WITDH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate cancelButtonPressed];
    }];
}

// Cancel+Feedback Animation
- (void)buttonPressedForColor:(Color)color {
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.4 animations:^{
        // Fade Background out
        self.backgroundView.alpha = 0;
        
        // Slide ActionSheet out
        if ([Device resolution] == IPHONE_SHORT) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_SHORT, WITDH, HEIGHT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.actionSheetView.frame = CGRectMake(0, HIDING_Y_IPHONE_LONG, WITDH, HEIGHT);
        }
        
    } completion:^(BOOL finished) {
    
        switch (color) {
            case BLUE:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueFeedback"]];
                break;
            case YELLOW:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowFeedback"]];
                break;
            case TURQUOISE:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"turquoiseFeedback"]];
                break;
            case GRAY:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayFeedback"]];
                break;
            case ROSE:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roseFeedback"]];
                break;
            case CORAL:
                self.feedbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coralFeedback"]];
                break;
            default:
                break;
        }
        
        // Fade FeedbackImageView in
        self.feedbackImageView.center = self.center;
        self.feedbackImageView.alpha = 0;
        [self addSubview:self.feedbackImageView];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:0.0 animations:^{
            self.feedbackImageView.alpha = 1;
        } completion:^(BOOL finished) {
            
            switch (color) {
                case BLUE:
                    [self.delegate blueButtonPressedForItem:self.item];
                    break;
                case YELLOW:
                    [self.delegate yellowButtonPressedForItem:self.item];
                    break;
                case TURQUOISE:
                    [self.delegate turquoiseButtonPressedForItem:self.item];
                    break;
                case GRAY:
                    [self.delegate grayButtonPressedForItem:self.item];
                    break;
                case ROSE:
                    [self.delegate roseButtonPressedForItem:self.item];
                    break;
                case CORAL:
                    [self.delegate coralButtonPressedForItem:self.item];
                    break;
                default:
                    break;
            }
            
            // Fade FeedbackImageView out
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView animateWithDuration:1 animations:^{
                self.feedbackImageView.alpha = 0;
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                [self.delegate cancelButtonPressed];
            }];
        }];
    }];
}


- (IBAction)blueButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.blueButton afterDelay:0.0];

    [self buttonPressedForColor:BLUE];
}

- (IBAction)yellowButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.yellowButton afterDelay:0.0];
    
    [self buttonPressedForColor:YELLOW];
}

- (IBAction)turquoiseButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.turquoiseButton afterDelay:0.0];
    
    [self buttonPressedForColor:TURQUOISE];
}

- (IBAction)grayButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.grayButton afterDelay:0.0];

    [self buttonPressedForColor:GRAY];
}

- (IBAction)roseButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.roseButton afterDelay:0.0];
    
    [self buttonPressedForColor:ROSE];
}

- (IBAction)coralButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.coralButton afterDelay:0.0];
    
    [self buttonPressedForColor:CORAL];
}

- (void)highlightButton:(UIButton*)button {
    button.highlighted = YES;
}

-(void)unhighlightAllButtons {
    self.blueButton.highlighted = NO;
    self.yellowButton.highlighted = NO;
    self.turquoiseButton.highlighted = NO;
    self.grayButton.highlighted = NO;
    self.roseButton.highlighted = NO;
    self.coralButton.highlighted = NO;
}

@end
