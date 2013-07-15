//
//  ALAssetsLibrary+PhotoAlbum.m
//  Text&Colour
//
//  Created by Lindemann on 03.02.13.
//  Copyright (c) 2013 LINDEMANN. All rights reserved.
//

#import "ALAssetsLibrary+PhotoAlbum.h"

@implementation ALAssetsLibrary (PhotoAlbum)

- (void)saveImage:(CGImageRef)imageRef withMetadata:(NSDictionary *)metadata inAlbum:(NSString*)albumName {
    // I dont understand the purpose of this method...
    [self writeImageToSavedPhotosAlbum:imageRef metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        // Test if an Album with $albumName allreday exists
        [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            // OH YES!
            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                // Generate Asset URL
                [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    // Add Asset to album
                    [group addAsset:asset];
                } failureBlock:nil];
                return;
            }
            // NO
            // Album with $albumName did'nt exist
            else {
                // Need a __weak instance of $library...of cause...
                __weak ALAssetsLibrary* weakLibrary = self;
                // Generate an Album with albumName
                [self addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                    // Generate Asset URL
                    [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        // Add Asset to album
                        [group addAsset:asset];
                    } failureBlock:nil];
                } failureBlock:nil];
                return;
            }
        } failureBlock:nil];
        // What could possibly go wrong???
    }];
}

@end
