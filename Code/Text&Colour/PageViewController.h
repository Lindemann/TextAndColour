//
//  PageViewController.h
//  Text&Colour
//
//  Created by Lindemann on 15.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+BugFix.h"

@interface PageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) int photoIndex;
@property (nonatomic, strong) Item *item;

@end
