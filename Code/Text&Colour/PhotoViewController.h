//
//  PhotoViewController.h
//  Text&Colour
//
//  Created by Lindemann on 15.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+BugFix.h"

@interface PhotoViewController : UIViewController

@property (nonatomic) int photoIndex;
@property (nonatomic, strong) Item *item;

- (id)initWithIndex:(int)index ForItem:(Item*)item;

@end
