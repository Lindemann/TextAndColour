//
//  PhotoFeedbackView.m
//  Text&Colour
//
//  Created by Lindemann on 28.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#import "PhotoFeedbackView.h"
#import "Device.h"

/*----------------------------------------------------------------------------------------------*/

#define WITDH 320
#define HEIGHT_IPHONE_SHORT 460
#define HEIGHT_IPHONE_LONG 548
#define X 0
#define Y 20

/*----------------------------------------------------------------------------------------------*/

@implementation PhotoFeedbackView

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    if (self = [super init]) {
        
        UIView *backgroundView = [UIView new];
        if ([Device resolution] == IPHONE_SHORT) {
            self.frame = CGRectMake(X, Y, WITDH, HEIGHT_IPHONE_SHORT);
            backgroundView.frame = CGRectMake(X, 0, WITDH, HEIGHT_IPHONE_SHORT);
        }
        if ([Device resolution] == IPHONE_LONG) {
            self.frame = CGRectMake(X, Y, WITDH, HEIGHT_IPHONE_LONG);
            backgroundView.frame = CGRectMake(X, 0, WITDH, HEIGHT_IPHONE_LONG);
        }
//        backgroundView.backgroundColor = [UIColor whiteColor];
//        backgroundView.alpha = 0;
//        [self addSubview:backgroundView];
        
        UIImageView *photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoFeedback"]];
        photoImageView.center = self.center;
        photoImageView.alpha = 0;
        
        [self addSubview:photoImageView];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:0.0 animations:^{
            photoImageView.alpha = 1;
        } completion:^(BOOL finished) {
        
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView animateWithDuration:1 animations:^{
                photoImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [photoImageView removeFromSuperview];
                [self removeFromSuperview];
                
                [self.delegate photoFeedBackAnimationEnds];
            }];
        }];
    }
    return self;
}

@end
