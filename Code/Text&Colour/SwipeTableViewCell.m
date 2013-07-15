//
//  TableViewCell.m
//  TableViewCell_OptionPanel
//
//  Created by Lindemann on 19.06.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "SwipeTableViewCell.h"
#import "SwipeButton.h"

@interface SwipeTableViewCell()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

@end

@implementation SwipeTableViewCell

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SwipeTableViewCell" owner:self options:nil];
    self = [nib objectAtIndex:0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Create the gesture recognizers
    self.swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRightInCell:)];
    [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    self.swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftInCell:)];
    [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self addGestureRecognizer:self.swipeRightGestureRecognizer];
    [self addGestureRecognizer:self.swipeLeftGestureRecognizer];
    
    self.button = [[SwipeButton alloc]init];
    [self addSubview:self.button];
    self.button.frame = CGRectMake(240, 0, 80, 80);
    [self.button addTarget:self action:@selector(buttonPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            SETTER                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)setColor:(Color)color {
    self.button.color = color;
    _color = color;
}

- (void)setCount:(int)count {
    _count = count;
    self.button.count = count;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                             SWIPE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

-(void)didSwipeLeftInCell:(id)sender {
    
    if ([self.delegate.searchDisplayController isActive]) {
        return;
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.2 animations:^{
        [self.imageBackgroundView setFrame:CGRectMake(-80, 0, 320, 80)];
        [self.label setFrame:CGRectMake(-60, 17, 203, 43)];
        [self.button setFrame:CGRectMake(160 + 1, 0, 80, 80)];
        
        CGPoint location = [self.swipeLeftGestureRecognizer locationInView:[self realTableView]];
        NSIndexPath *indexPath = [[self realTableView] indexPathForRowAtPoint:location];
        [self.delegate prepareForOpenSwipeInTableView:[self realTableView] atIndexPath:indexPath];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            //            [_topView setFrame:CGRectMake(0, 0, 320, 80)];
        }];
    }];
}

-(void)didSwipeRightInCell:(id)sender {
    
    if ([self.delegate.searchDisplayController isActive]) {
        return;
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.2 animations:^{
        [self.imageBackgroundView setFrame:CGRectMake(0, 0, 320, 80)];
        [self.label setFrame:CGRectMake(20, 17, 203, 43)];
        [self.button setFrame:CGRectMake(240, 0, 80, 80)];
        
        CGPoint location = [self.swipeRightGestureRecognizer locationInView:[self realTableView]];
        NSIndexPath *indexPath = [[self realTableView] indexPathForRowAtPoint:location];
        [self.delegate prepareForCloseSwipeInTableView:[self realTableView] atIndexPath:indexPath];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            //            [_topView setFrame:CGRectMake(0, 0, 320, 80)];
        }];
    }];
}

-(void)closeCell {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.2 animations:^{
        [self.imageBackgroundView setFrame:CGRectMake(0, 0, 320, 80)];
        [self.label setFrame:CGRectMake(20, 17, 203, 43)];
        [self.button setFrame:CGRectMake(240, 0, 80, 80)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            //            [_topView setFrame:CGRectMake(0, 0, 320, 80)];
        }];
    }];
}

-(void)openCell {
    [self.imageBackgroundView setFrame:CGRectMake(-80, 0, 320, 80)];
    [self.label setFrame:CGRectMake(-60, 17, 203, 43)];
    [self.button setFrame:CGRectMake(160 + 1, 0, 80, 80)];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                      LITTLE HELPER                                           */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

// Return the correct TableView
-(UITableView*)realTableView {
    if ([self.delegate.searchDisplayController isActive]) {
        return self.delegate.searchDisplayController.searchResultsTableView;
    } else {
        return self.delegate.tableView;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         REORDERING                                           */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing: editing animated: YES];
    
    for (UIView * privateView in self.subviews) {
        if ([NSStringFromClass([privateView class]) rangeOfString: @"Reorder"].location != NSNotFound) {
            
            //            [privateView setBackgroundColor:[UIColor redColor]];
            
            //            [self.reorderView addSubview:privateView];
            // iPad portrait 688
            UIView * resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(240, 0, CGRectGetMaxX(privateView.frame), CGRectGetMaxY(privateView.frame))];
            //            [resizedGripView setBackgroundColor:[UIColor greenColor]];
            [resizedGripView addSubview:privateView];
            [self.reorderView addSubview:resizedGripView];
            
            CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - privateView.frame.size.width, resizedGripView.frame.size.height - privateView.frame.size.height);
            CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / privateView.frame.size.width, resizedGripView.frame.size.height / privateView.frame.size.height);
            
            //	Original transform
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            //	Scale custom view so grip will fill entire cell
            transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
            
            //	Move custom view so the grip's top left aligns with the cell's top left
            transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
            
            [resizedGripView setTransform:transform];
            
            for (UIView * subview in privateView.subviews) {
                if ([subview isKindOfClass: [UIImageView class]]) {
                    ((UIImageView *)subview).image = nil;
                }
            }
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           BUTTON                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

- (void)buttonPressed:(UIButton *)sender forEvent:(UIEvent *)event {
    //Finds out the indexPath of touched cell
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:[self realTableView]];
	NSIndexPath *indexPath = [[self realTableView] indexPathForRowAtPoint: currentTouchPosition];
    
    [self.delegate tableView:[self realTableView] didPressButtonAtIndexPath:indexPath];
}

@end
