//
//  PhotoFeedbackView.h
//  Text&Colour
//
//  Created by Lindemann on 28.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoFeedbackViewProtocol;

@interface PhotoFeedbackView : UIView

@property (nonatomic, weak) id <PhotoFeedbackViewProtocol> delegate;

@end

@protocol PhotoFeedbackViewProtocol <NSObject>

- (void)photoFeedBackAnimationEnds;

@end