//
//  SettingsTableViewController.h
//  Text&Colour
//
//  Created by Lindemann on 26.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSwitchOnOff.h"

@interface SettingsTableViewController : UITableViewController <RCSwitchDelegate>

@property (weak, nonatomic) IBOutlet UIView *savePhotosSwitchView;
@property (nonatomic, strong) RCSwitchOnOff *savePhotoSwitch;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *turquoiseButton;
@property (weak, nonatomic) IBOutlet UIButton *roseButton;
@property (weak, nonatomic) IBOutlet UIButton *coralButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)grayButtonPressed;
- (IBAction)blueButtonPressed;
- (IBAction)turquoiseButtonPressed;
- (IBAction)roseButtonPressed;
- (IBAction)coralButtonPressed;
- (IBAction)yellowButtonPressed;

- (IBAction)resetButtonPressed;


@end
