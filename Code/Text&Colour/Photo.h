//
//  Photo.h
//  Text&Colour
//
//  Created by Lindemann on 27.11.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSData * thumbData;
@property (nonatomic, retain) Item *item;

@end
