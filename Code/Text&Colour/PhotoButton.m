//
//  PhotoButton.m
//  Text&Colour
//
//  Created by Lindemann on 03.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "PhotoButton.h"

@interface PhotoButton ()

@property (nonatomic, strong) UIButton *thumbnailButton;
@property (nonatomic, strong) UIImage *thumbnail;

@end

@implementation PhotoButton

- (id)init {
    self = [super init];
    if (self) {
        
        UIImage *backgroundImage = [UIImage imageNamed:@"imageButtonBackground"];
        UIImage *backgroundImageHighlighted = [UIImage imageNamed:@"imageButtonBackground_highlighted"];
        [self setImage:backgroundImage forState:UIControlStateNormal];
        [self setImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        self.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        [self addTarget:self action:@selector(buttonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setPhoto:(Photo *)photo {
    _photo = photo;
    
    self.thumbnail = [UIImage imageWithData:self.photo.thumbData];
    self.thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.thumbnailButton.frame = CGRectMake(9, 9, 270, 50);
    self.thumbnailButton.userInteractionEnabled = NO;
    [self.thumbnailButton setBackgroundImage:self.thumbnail forState:UIControlStateNormal];
    
    [self addSubview:self.thumbnailButton];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.thumbnailButton.highlighted = highlighted;
}

- (void)buttonWasPressed {
    [self.delegate thumbnailButtonWasPressedAtIndex:self.photoIndex ForItem:self.item];
}


@end
