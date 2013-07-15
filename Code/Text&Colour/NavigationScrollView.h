//
//  NavigationScrollView.h
//  ScrollItem
//
//  Created by Lindemann on 16.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationSubView.h"

/*----------------------------------------------------------------------------------------------*/

@protocol NavigationScrollViewProtocol;

/*----------------------------------------------------------------------------------------------*/

@interface NavigationScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NavigationSubView *subView1;
@property (nonatomic, strong) NavigationSubView *subView2;

@property (nonatomic, weak) UITableViewController <NavigationScrollViewProtocol> *navigationScrollViewProtocoldelegate;

@end

/*----------------------------------------------------------------------------------------------*/

@protocol NavigationScrollViewProtocol <NSObject>

- (void)navigationScrollViewWasSwiped;

@end