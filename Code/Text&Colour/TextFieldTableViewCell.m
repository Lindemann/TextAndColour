//
//  TextFieldTableViewCell.m
//  Text&Colour
//
//  Created by Lindemann on 18.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "PhotoButton.h"
#import "Photo.h"

#define PHOTOBUTTON_HEIGHT 69
#define PHOTOBUTTON_MARGIN 12
#define DETAILCELL_PADDING_WITH_PHOTO 23
#define PHOTOBUTTON_X 16

@interface TextFieldTableViewCell ()

@property (nonatomic, strong) NSString *text;

@end

@implementation TextFieldTableViewCell

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell" owner:self options:nil];
    self = [nib objectAtIndex:0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set BackgroundImage with UIEdgeInsetsMake
    UIImage *image = [[UIImage imageNamed:@"textFieldCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
    self.backgroundImageView.image = image;
    
    return self;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                        SETTER & GETTER                                       */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)setItem:(Item *)item {
    _item = item;
    self.text = self.item.text;
    
    [self managePhotoButtons];
}

- (void)managePhotoButtons {
    // PhotoButton must at first become removed
    // else new Buttuns became added over the old ones
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PhotoButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (_item.photos.count > 0) {
        
        int y = self.labelHeight + DETAILCELL_PADDING_WITH_PHOTO;
        
        for (int i = 0; i < _item.photos.count; ++i) {
            PhotoButton *photoButton = [[PhotoButton alloc]init];
            photoButton.photo = [self.item.photos objectAtIndex:i];
            photoButton.item = self.item;
            photoButton.photoIndex = i;
            photoButton.delegate = self.photoButtonDelegate;
            
            photoButton.frame = CGRectMake(PHOTOBUTTON_X, y, photoButton.frame.size.width, photoButton.frame.size.height);
            [self addSubview:photoButton];
            y+= PHOTOBUTTON_MARGIN + PHOTOBUTTON_HEIGHT;
        }
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.label.text = text;
    
    // Resize Label
    self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y, 280, 0);
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
    
    self.labelHeight = self.label.frame.size.height;
}


@end
