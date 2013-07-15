//
//  Item+BugFix.m
//  Text&Colour
//
//  Created by Judith Lindemann on 08.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "Item+BugFix.h"

@implementation Item (BugFix)

- (void)addChildrenObject:(Item *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.children];
    [tempSet addObject:value];
    self.children = tempSet;
}

- (void)removeChildrenObject:(Item *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.children];
    [tempSet removeObject:value];
    self.children = tempSet;
}

- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.children];
    [tempSet insertObjects:value atIndexes:indexes];
    self.children = tempSet;
}

- (void)addPhotosObject:(Photo *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.photos];
    [tempSet addObject:value];
    self.photos = tempSet;
}

- (void)removePhotosObject:(Photo *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.photos];
    [tempSet removeObject:value];
    self.photos = tempSet;
}



@end
