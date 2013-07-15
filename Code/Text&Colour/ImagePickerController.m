//
//  ImagePickerController.m
//  Text&Colour
//
//  Created by Lindemann on 04.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "ImagePickerController.h"
#import "AppDelegate.h"

@interface ImagePickerController ()

@end

@implementation ImagePickerController

- (id)init {
    self = [super init];
    if (self) {
        
        // Style NavigationBar
        UIImage *image = [[UIImage imageNamed:@"addOrEditItemNavBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"shadow"]];
        
        // Rounded Corners for the NavigationBar
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.backgroundColor = [UIColor blackColor];
        CALayer *capa = self.navigationBar.layer;
        CGRect bounds = capa.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        [capa addSublayer:maskLayer];
        capa.mask = maskLayer;
    }
    return self;
}

@end
