//
//  NavigationSubView.m
//  ScrollItem
//
//  Created by Lindemann on 16.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "NavigationSubView.h"

@implementation NavigationSubView

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationSubView" owner:self options:nil];
    self = [nib objectAtIndex:0];
    return self;
}

@end
