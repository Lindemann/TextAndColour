//
//  TextFieldTableViewCell.h
//  Text&Colour
//
//  Created by Lindemann on 18.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+BugFix.h"
#import "PhotoButton.h"

@interface TextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

// labelHeight is public for debugging
@property (nonatomic) int labelHeight;
@property (nonatomic, strong) Item *item;

@property (nonatomic, weak) id <PhotoButtonDelegate> photoButtonDelegate;

@end
