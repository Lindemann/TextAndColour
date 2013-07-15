//
//  Settings.h
//  Text&Colour
//
//  Created by Lindemann on 03.02.13.
//  Copyright (c) 2013 LINDEMANN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic) int32_t defaultColor;
@property (nonatomic) BOOL savePhotos;

@end
