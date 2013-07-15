//
//  NavigationScrollView.m
//  ScrollItem
//
//  Created by Lindemann on 16.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#define HEIGHT 44
//#define WIDTH 180
#define WIDTH 245

/*----------------------------------------------------------------------------------------------*/

#import "NavigationScrollView.h"

/*----------------------------------------------------------------------------------------------*/

@implementation NavigationScrollView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(WIDTH*2, HEIGHT);
        self.delegate = self;
        
        self.subView1 = [[NavigationSubView alloc] init];
        self.subView1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.subView1.label.text = @"subView1";
        self.subView2 = [[NavigationSubView alloc] init];
        self.subView2.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);
        self.subView2.label.text = @"subView2";
        [self addSubview:self.subView1];
        [self addSubview:self.subView2];
        
        [self scrollRectToVisible:self.subView2.frame animated:NO];
        
        self.subView1.backgroundColor = [UIColor clearColor];
        self.subView2.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
//        self.subView1.backgroundColor = [UIColor blueColor];
//        self.subView2.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self changePositionFromView:self.subView1 withView:self.subView2];
        CGRect position02 = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);
        [scrollView scrollRectToVisible:position02 animated:NO];
        
        [self.navigationScrollViewProtocoldelegate navigationScrollViewWasSwiped];
    }
    if (scrollView.contentOffset.x == WIDTH) {
//        NSLog(@"%d", CGRectIntersectsRect(scrollView.bounds, self.subView1.frame));
    }
}

- (void)changePositionFromView:(UIView*)view1 withView:(UIView*)view2 {
    CGRect tmpFrame = view1.frame;
    view1.frame = view2.frame;
    view2.frame = tmpFrame;
}

@end
