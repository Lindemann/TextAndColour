//
//  Item+BugFix.h
//  Text&Colour
//
//  Created by Judith Lindemann on 08.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "Item.h"

@interface Item (BugFix)

//- (void)insertObject:(Item *)value inChildrenAtIndex:(NSUInteger)idx;
//- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
//- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(Item *)value;
//- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(Item *)value;
- (void)removeChildrenObject:(Item *)value;
//- (void)addChildren:(NSOrderedSet *)values;
//- (void)removeChildren:(NSOrderedSet *)values;

//- (void)insertObject:(Photo *)value inPhotosAtIndex:(NSUInteger)idx;
//- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
//- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
//- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
//- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)values;
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
//- (void)addPhotos:(NSOrderedSet *)values;
//- (void)removePhotos:(NSOrderedSet *)values;

@end
