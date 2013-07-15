//
//  Device.h
//  Text&Colour
//
//  Created by Lindemann on 17.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IPAD,
    IPHONE
} Devices;

typedef enum {
    IPHONE_SHORT,
    IPHONE_LONG
} Resolution;

@interface Device : NSObject

+ (Devices)device;
+ (Resolution)resolution;

@end
