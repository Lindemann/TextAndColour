//
//  ALAssetsLibrary+PhotoAlbum.h
//  Text&Colour
//
//  Created by Lindemann on 03.02.13.
//  Copyright (c) 2013 LINDEMANN. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (PhotoAlbum)

- (void)saveImage:(CGImageRef)imageRef withMetadata:(NSDictionary *)metadata inAlbum:(NSString*)albumName;

@end
