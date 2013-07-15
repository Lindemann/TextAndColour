//
//  PageViewController.m
//  Text&Colour
//
//  Created by Lindemann on 15.12.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "PageViewController.h"
#import "AppDelegate.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "OtherItemTableViewController.h"
#import "DeletePhotoActionSheetView.h"
#import "Device.h"

@interface PageViewController () <DeletePhotoActionSheetDelegate>

@property (nonatomic) int currentIndex;
@property (nonatomic, strong) UILabel *label;

@end

@implementation PageViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.currentIndex = self.photoIndex;
    
	// Set Done Button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"photoBrowserNavBarButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"photoBrowserNavBarButton_highlighted"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneButton;
    // Done Button Font Color
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor colorWithRed:0.72f green:0.75f blue:0.78f alpha:1.00f], UITextAttributeTextShadowColor, CGSizeMake(0, 1), UITextAttributeTextShadowOffset, nil] forState:UIControlStateNormal];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor colorWithRed:0.53f green:0.56f blue:0.58f alpha:1.00f], UITextAttributeTextShadowColor, CGSizeMake(0, 1), UITextAttributeTextShadowOffset, nil] forState:UIControlStateHighlighted];
    
    // Style NavigationBar
    [self styleNavBar];
    self.title = self.item.text;

    // Set first ViewController
    PhotoViewController *photoViewController = [[PhotoViewController alloc]initWithIndex:self.photoIndex ForItem:self.item];
    [self setViewControllers:@[photoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Backgroundcolor
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.96f blue:0.98f alpha:1.00f];
    
    // Round top corners
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;

    // Add Toolbar
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = YES;
    [self.navigationController.toolbar setShadowImage:[UIImage imageNamed:@"shadow"] forToolbarPosition:UIToolbarPositionBottom];
    UIImage *image = [[UIImage imageNamed:@"photoBrowserToolBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 1, 0)];
    [self.navigationController.toolbar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    // Trash Button
    UIImage *trashImage = [UIImage imageNamed:@"photoTrash"];
    UIButton *trashButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, trashImage.size.width, trashImage.size.height)];
    [trashButton setBackgroundImage:trashImage forState:UIControlStateNormal];
    UIImage *trashImage_highlighted = [UIImage imageNamed:@"photoTrash_highlighted"];
    [trashButton setBackgroundImage:trashImage_highlighted forState:UIControlStateHighlighted];
    
    [trashButton addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    UIView *trashView = [[UIView alloc]initWithFrame:trashButton.frame];
    [trashView addSubview:trashButton];
    UIBarButtonItem *trashBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trashView];
    
    // Flexible Space
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Label
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.label.text = [NSString stringWithFormat:@"%d / %d", self.photoIndex + 1, self.item.photos.count];
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor colorWithRed:0.65f green:0.67f blue:0.69f alpha:1.00f];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.shadowColor = [UIColor whiteColor];
    self.label.shadowOffset = CGSizeMake(0, 1);
    [self.label sizeToFit];
    
    UIView *labelView = [[UIView alloc]initWithFrame:self.label.frame];
    [labelView addSubview:self.label];
    UIBarButtonItem *labelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:labelView];
    
    NSArray* toolbarItems = @[trashBarButtonItem, flexibleSpace, labelBarButtonItem];
    self.toolbarItems = toolbarItems;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                PAGEVIEWCONTROLLER DELEGATES                                  */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - PageViewController Delegates

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((PhotoViewController*)viewController).photoIndex;
    PhotoViewController *photoViewController = [[PhotoViewController alloc]initWithIndex:index+1 ForItem:self.item];
    return photoViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((PhotoViewController*)viewController).photoIndex;
    PhotoViewController *photoViewController = [[PhotoViewController alloc]initWithIndex:index-1 ForItem:self.item];
    return photoViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.currentIndex = ((PhotoViewController*)[self.viewControllers objectAtIndex:self.viewControllers.count-1]).photoIndex;
    self.label.text = [NSString stringWithFormat:@"%d / %d", self.currentIndex+1, self.item.photos.count];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            OTHER                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Other

- (void)styleNavBar {
    UIImage *image = [[UIImage imageNamed:@"photoBrowserNavBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"shadow"]];
    
    self.navigationController.navigationBar.translucent = YES;
    
    // Rounded Corners for the NavigationBar
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.backgroundColor = [UIColor blackColor];
    
    CALayer *capa = self.navigationController.navigationBar.layer;
    CGRect bounds = capa.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
    
    // Style Title
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.65f green:0.67f blue:0.69f alpha:1.00f], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset, [UIFont systemFontOfSize:19], UITextAttributeFont, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault];
}

- (void)done {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)deletePhoto {        
    DeletePhotoActionSheetView *customActionSheetView = [[DeletePhotoActionSheetView alloc] init];
    
    // Creepy Issue...without that step the View would beginn behind the Statusbar
    if ([Device resolution] == IPHONE_LONG) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
    }
    if ([Device resolution] == IPHONE_SHORT) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
    }
    
    customActionSheetView.delegate = self;
    [self.navigationController.view addSubview:customActionSheetView];
                                                            
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                               DELETEPHOTOACTIONSHEET DELEGATE                                */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - DeletePhotoActionSheetView delegate

- (void)deletPhotoButtonPressed {
    // Remove the real Photo in the DB
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext deleteObject:[self.item.photos objectAtIndex:self.currentIndex]];
    [appDelegate saveContext];
    
//    if (self.currentIndex > 0) {
//        PhotoViewController *photoViewController = [[PhotoViewController alloc]initWithIndex:self.currentIndex-1 ForItem:self.item];
//        [self setViewControllers:@[photoViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
//        self.currentIndex = self.currentIndex-1;
//    } else {
//        UINavigationController *navigationController = (UINavigationController*)self.navigationController.presentingViewController;
//        OtherItemTableViewController *otherItemTableViewController = [navigationController.viewControllers lastObject];
//        [otherItemTableViewController updateItems];
//        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
//    }
}

- (void)dismissHostController {
    // Dismiss self and Update TableView
    UINavigationController *navigationController = (UINavigationController*)self.navigationController.presentingViewController;
    OtherItemTableViewController *otherItemTableViewController = [navigationController.viewControllers lastObject];
    [otherItemTableViewController updateItems];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
