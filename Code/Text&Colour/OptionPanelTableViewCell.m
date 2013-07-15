//
//  OptionPanelTableViewCell.m
//  Text&Colour
//
//  Created by Lindemann on 11.07.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "OptionPanelTableViewCell.h"

@implementation OptionPanelTableViewCell

- (id)init {
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"OptionPanelTableViewCell" owner:self options:nil];
    self = [nib objectAtIndex:0];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (IBAction)colorButtonPressed {
    [self.delegate chooseColorInTableView:[self realTableView] atSwipeCellIndexPath:self.aboveCellIndexPath];
}

- (IBAction)editButtonPressed {
    [self.delegate editItemInTableView:[self realTableView] atSwipeCellIndexPath:self.aboveCellIndexPath];
}

- (IBAction)photoButtonPressed {
    [self.delegate addPhotoInTableView:[self realTableView] atSwipeCellIndexPath:self.aboveCellIndexPath];
}

- (IBAction)trashButtonPressed {
    [self.delegate deleteItemInTableView:[self realTableView] atSwipeCellIndexPath:self.aboveCellIndexPath];
}

// Return the correct TableView
-(UITableView*)realTableView {
    if ([self.delegate.searchDisplayController isActive]) {
        return self.delegate.searchDisplayController.searchResultsTableView;
    } else {
        return self.delegate.tableView;
    }
}

@end
