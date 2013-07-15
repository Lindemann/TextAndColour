//
//  PhotoButton.h
//  Text&Colour
//
//  Created by Lindemann on 03.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Item+BugFix.h"

@protocol PhotoButtonDelegate;

@interface PhotoButton : UIButton

@property (nonatomic, strong) Photo *photo;
@property (nonatomic) int photoIndex;
@property (nonatomic, strong) Item *item;
@property (nonatomic, weak) id <PhotoButtonDelegate> delegate;

@end

@protocol PhotoButtonDelegate <NSObject>

- (void)thumbnailButtonWasPressedAtIndex:(int)index ForItem:(Item*)item;

@end