//
//  SettingsTableViewController.m
//  Text&Colour
//
//  Created by Lindemann on 26.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"
#import "ColorConstants.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation SettingsTableViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Style NavBar
    [self styleNavigationBar];
    
    // Set Done Button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set Switches
    self.savePhotoSwitch = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(0, 0, 78, 43)];
    [self.savePhotoSwitch setOn:YES];
    
    [self.savePhotosSwitchView addSubview:self.savePhotoSwitch];
    
    // ResetButton Styling
    [self styleResetButton];
    
    // Get Default Color for DropButtons
    [self getDefaultColor];
    
    // Get savePhotState
    self.savePhotoSwitch.on = self.appDelegate.settings.savePhotos;
    self.savePhotoSwitch.delegate = self;
}

- (void)viewDidUnload {
    [self setSavePhotosSwitchView:nil];
    [self setGrayButton:nil];
    [self setBlueButton:nil];
    [self setTurquoiseButton:nil];
    [self setRoseButton:nil];
    [self setCoralButton:nil];
    [self setYellowButton:nil];
    [self setResetButton:nil];
    [super viewDidUnload];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           STYLING                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Styling

- (void)styleNavigationBar {
    UIImage *image = [[UIImage imageNamed:@"addOrEditItemNavBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // Rounded Corners for the NavigationBar
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.backgroundColor = [UIColor blackColor];
    CALayer *capa = [self.navigationController navigationBar].layer;
    CGRect bounds = capa.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Fuck!...this Shit is necssesary to change the fucking color of the header labels
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
	tableView.sectionHeaderHeight = headerView.frame.size.height;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, headerView.frame.size.width - 20, 22)];
	label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont systemFontOfSize:17];
	label.shadowOffset = CGSizeMake(0, 1);
	label.shadowColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
    
    label.textColor = [UIColor colorWithRed:0.57f green:0.60f blue:0.61f alpha:1.00f];

    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    
	[headerView addSubview:label];
	return headerView;
}

- (void)getDefaultColor {
    switch (self.appDelegate.settings.defaultColor) {
        case BLUE:
            [self highlightButton:self.blueButton];
            break;
        case YELLOW:
            [self highlightButton:self.yellowButton];
            break;
        case TURQUOISE:
            [self highlightButton:self.turquoiseButton];
            break;
        case GRAY:
            [self highlightButton:self.grayButton];
            break;
        case ROSE:
            [self highlightButton:self.roseButton];
            break;
        case CORAL:
            [self highlightButton:self.coralButton];
            break;
        default:
            break;
    }
}

- (void)styleResetButton {
    UIImage *image = [[UIImage imageNamed:@"photoCustomActionSheetButton.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *image_highlighted = [[UIImage imageNamed:@"photoCustomActionSheetButton_highlighted.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.resetButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.resetButton setBackgroundImage:image_highlighted forState:UIControlStateHighlighted];
    self.resetButton.contentMode = UIViewContentModeScaleToFill;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           BUTTONS                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Buttons

- (void)doneButtonPressed {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)blueButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.blueButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = BLUE;
    [self.appDelegate saveContext];
}

- (IBAction)yellowButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.yellowButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = YELLOW;
    [self.appDelegate saveContext];
}

- (IBAction)turquoiseButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.turquoiseButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = TURQUOISE;
    [self.appDelegate saveContext];
}

- (IBAction)grayButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.grayButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = GRAY;
    [self.appDelegate saveContext];
}

- (IBAction)roseButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.roseButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = ROSE;
    [self.appDelegate saveContext];
}

- (IBAction)coralButtonPressed {
    [self unhighlightAllButtons];
    [self performSelector:@selector(highlightButton:) withObject:self.coralButton afterDelay:0.0];
    
    self.appDelegate.settings.defaultColor = CORAL;
    [self.appDelegate saveContext];
}

- (void)highlightButton:(UIButton*)button {
    button.highlighted = YES;
}

- (void)unhighlightAllButtons {
    self.blueButton.highlighted = NO;
    self.yellowButton.highlighted = NO;
    self.turquoiseButton.highlighted = NO;
    self.grayButton.highlighted = NO;
    self.roseButton.highlighted = NO;
    self.coralButton.highlighted = NO;
}

- (IBAction)resetButtonPressed {
    self.savePhotoSwitch.on = YES;
    self.appDelegate.settings.savePhotos = YES;
    
    [self grayButtonPressed];
    self.appDelegate.settings.defaultColor = GRAY;
    
    [self.appDelegate saveContext];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                   RCSWITCH DELEGATE                                          */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - RCSwitch Delegate

- (void)switchWasDraged:(RCSwitch *)rcswitch {
    // Save Photos Switch
    if (rcswitch == self.savePhotoSwitch) {
        if (rcswitch.on) {
            self.appDelegate.settings.savePhotos = YES;
        } else {
            self.appDelegate.settings.savePhotos = NO;
        }
        [self.appDelegate saveContext];
    }
}

@end
