//
//  ImagePickerController.h
//  Text&Colour
//
//  Created by Lindemann on 04.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ImagePickerController : UIImagePickerController

@property (nonatomic, strong) NSIndexPath *swipeCellIndexPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Item *item;

@end
