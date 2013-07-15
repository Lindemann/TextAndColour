//
//  Device.m
//  Text&Colour
//
//  Created by Lindemann on 17.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "Device.h"
#import "AppDelegate.h"

@implementation Device

+ (Devices)device {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return IPAD;
    } else {
        return IPHONE;
    }
}

+ (Resolution)resolution {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (roundf(appDelegate.window.frame.size.height) == 568) {
        return IPHONE_LONG;
    } else {
        return IPHONE_SHORT;
    }
}

@end
