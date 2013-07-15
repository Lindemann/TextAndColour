//
//  NumberButton.m
//  NumberButton
//
//  Created by Lindemann on 17.07.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "SwipeButton.h"

@interface SwipeButton ()

@property (nonatomic, strong) UIButton *arrowButton;

@end

@implementation SwipeButton

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init
{
    self = [super init];
    if (self) {
        
        // GrayArrow
//        UIImage *grayImage = [[UIImage imageNamed:@"gray_btn"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 10)];
        UIImage *grayImage = [UIImage imageNamed:@"arrowButton"];
        
        self.arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.arrowButton.frame = CGRectMake(0, 0, grayImage.size.width, grayImage.size.height);
        [self.arrowButton setBackgroundImage:grayImage forState:UIControlStateNormal];
        self.arrowButton.userInteractionEnabled = NO;
        
        self.arrowButton.imageView.contentMode = UIViewContentModeRight;
        
        self.arrowButton.titleLabel.font = [UIFont systemFontOfSize:14];
        // Replace the title a little bit
        self.arrowButton.titleEdgeInsets = UIEdgeInsetsMake(0.5, 0, 0, 0);
//        self.arrowButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 10);
        [self.arrowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.arrowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                
        // Main Button       
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.arrowButton];
        self.arrowButton.center = CGPointMake(40, 40);
        
        // Frame of self is set in SwipeTableViewCell
        // because the 
        // self.frame = CGRectMake(240, 0, 80, 80);
    }
    return self;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            SETTER                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)setCount:(int)count {
    _count = count;
    if (count > 999) {
        [self.arrowButton setTitle:@"∞" forState:UIControlStateNormal];
    } else {
        [self.arrowButton setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.arrowButton.highlighted = highlighted;
}

- (void)setColor:(Color)color {
    UIImage *image;
    switch (color) {
        case BLUE:
            image = [UIImage imageNamed:@"swipeButton_blue"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        case YELLOW:
            image = [UIImage imageNamed:@"swipeButton_yellow"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        case TURQUOISE:
            image = [UIImage imageNamed:@"swipeButton_turquoise"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        case GRAY:
            image = [UIImage imageNamed:@"swipeButton_gray"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        case ROSE:
            image = [UIImage imageNamed:@"swipeButton_rose"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        case CORAL:
            image = [UIImage imageNamed:@"swipeButton_coral"];
            [self setImage:image forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self setImage:image forState:UIControlStateDisabled];
    _color = color;
}

@end
