//
//  AddEntryViewController.m
//  EarlyBirdToDo
//
//  Created by Judith Lindemann on 25.12.11.
//  Copyright (c) 2011 LINDEMANN. All rights reserved.
//

#import "AddOrEditItemViewController.h"
#import "AppDelegate.h"
#import "FirstItemTableViewController.h"
#import "OtherItemTableViewController.h"
#import "Device.h"
#import "Photo.h"
#import "ALAssetsLibrary+PhotoAlbum.h"

/*----------------------------------------------------------------------------------------------*/

@interface AddOrEditItemViewController()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) ImagePickerController *imagePickerController;

// Crap Tmp Vars are nessecariy to hold some values that can become deleted or saved in dependence on
// wether the User pressed the save or cancel button
@property (nonatomic) Color tmpColor;
@property (nonatomic) BOOL colorWasChanged;
// The Arrays are nessecariy because it is possible that more than 1 photos become added
@property (nonatomic, strong) NSMutableArray *tmpImagePickerArray;
@property (nonatomic, strong) NSMutableArray *tmpPhotoInfoArray;

@end

/*----------------------------------------------------------------------------------------------*/

@implementation AddOrEditItemViewController

/*----------------------------------------------------------------------------------------------*/

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (self.mode == ADDMODE) {
        self.title = @"Add a new Item";
        self.currentItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.parent.managedObjectContext];
        self.currentItem.color = self.appDelegate.settings.defaultColor;
    } else {
        self.title = @"Edit Item";
    }
    
    // Set TextView
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:19];
    self.textView.textColor = [UIColor colorWithRed:0.31f green:0.33f blue:0.33f alpha:1.00f];
    self.textView.delegate = self;
    
    [self.textView becomeFirstResponder];
    [self registerForKeyboardNotifications];
    
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    // Set Buttons
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Set AddOptionPanelView
    AddOrEditItemOptionPanelView *addOptionPanelView = [[AddOrEditItemOptionPanelView alloc] init];
    addOptionPanelView.delegate = self;
    self.textView.inputAccessoryView = addOptionPanelView;
    
    // Style NavigationBar
    UIImage *image = [[UIImage imageNamed:@"addOrEditItemNavBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // Rounded Corners for the NavigationBar
    self.appDelegate.window.backgroundColor = [UIColor blackColor];
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
    
    // Init Crap Tmp Arrays
    self.tmpImagePickerArray = [NSMutableArray new];
    self.tmpPhotoInfoArray = [NSMutableArray new];
    
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           SETTER                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Setter

- (void)setTmpColor:(Color)tmpColor {
    _tmpColor = tmpColor;
    
    self.colorWasChanged = YES;
    if (self.textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           BUTTONS                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - NavBarButtons

- (void) saveItem {
    
    // Set new Color and new Image when Item become saved
    if (self.colorWasChanged) {
        self.currentItem.color = self.tmpColor;
    }
    
    if (self.tmpPhotoInfoArray.count > 0) {
        for (int i = 0; i < self.tmpPhotoInfoArray.count; ++i) {
            [self savePhotoInLibrary:[self.tmpImagePickerArray objectAtIndex:i] ForInfo:[self.tmpPhotoInfoArray objectAtIndex:i]];
            [self savePhotoInDBWithInfo:[self.tmpPhotoInfoArray objectAtIndex:i]];
        }
    }
    
    self.currentItem.text = self.textView.text;
    
    if (self.mode == ADDMODE) {
        [self.parent addChildrenObject:self.currentItem];
        self.currentItem.index = [self.currentItem.parent.children indexOfObject:self.currentItem];
    }
    
    [self.appDelegate saveContext];
    
    UINavigationController *navigationController = (UINavigationController*)self.navigationController.presentingViewController;
    UITableViewController *presentingController = [navigationController.viewControllers lastObject];

    // Needed for indexPath of new Cell
    NSArray *data;
    int section = 0;
    
    if ([presentingController isKindOfClass:[FirstItemTableViewController class]]) {
        [(FirstItemTableViewController*)presentingController updateItems];
        data = [(FirstItemTableViewController*)presentingController data];
        section = 0;
      
    }
    if ([presentingController isKindOfClass:[OtherItemTableViewController class]]) {
        [(OtherItemTableViewController*)presentingController updateItems];
        data = [(OtherItemTableViewController*)presentingController data];
        section = 1;
    }
    
    if (self.mode == ADDMODE) {
        // Scrolls the TableView to the new Cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:data.count - 1 inSection:section];
        [presentingController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // back
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    if (self.mode == ADDMODE) {
        [self.appDelegate.managedObjectContext deleteObject:self.currentItem];
    }
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                       TEXTVIEW DELEGETE                                      */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - TexViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.textView.text length] >= 1) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                       KEYBOARD HANDLING                                      */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - KeyBoard Hnadler

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];    
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}



/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                       OPTIONPANEL DELEGETE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - OptionPanel Delegate

- (void)chooseColorForItem {
    [self.textView resignFirstResponder];
    
    ColorActionSheetView *customActionSheetView = [[ColorActionSheetView alloc] init];
    
    // Creepy Issue...without that step the View would beginn behind the Statusbar
    if ([Device resolution] == IPHONE_LONG) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
    }
    if ([Device resolution] == IPHONE_SHORT) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
    }

    
    customActionSheetView.item = self.currentItem;
    customActionSheetView.delegate = self;
    [self.navigationController.view addSubview:customActionSheetView];
}

- (void)addPhotoForItem {
    [self.textView resignFirstResponder];
    
    PhotoActionSheetView *customActionSheetView = [[PhotoActionSheetView alloc] init];
    
    // Creepy Issue...without that step the View would beginn behind the Statusbar
    if ([Device resolution] == IPHONE_LONG) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
    }
    if ([Device resolution] == IPHONE_SHORT) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
    }
    
    customActionSheetView.item = self.currentItem;
    customActionSheetView.delegate = self;
    [self.navigationController.view addSubview:customActionSheetView];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              CUSTOMACTIONSHEETVIEW DELEGATE                                  */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - CustomActionsheet Delegate

- (void)cancelButtonPressed {
    [self.textView becomeFirstResponder];
}

- (void)blueButtonPressedForItem:(Item*)item {
    self.tmpColor = BLUE;
}

- (void)yellowButtonPressedForItem:(Item*)item {
    self.tmpColor = YELLOW;
}

- (void)turquoiseButtonPressedForItem:(Item*)item {
    self.tmpColor = TURQUOISE;
}

- (void)grayButtonPressedForItem:(Item*)item {
    self.tmpColor = GRAY;
}

- (void)roseButtonPressedForItem:(Item*)item {
    self.tmpColor = ROSE;
}

- (void)coralButtonPressedForItem:(Item*)item {
    self.tmpColor = CORAL;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              PHOTOACTIONSHEETVIEW DELEGATE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - PhotoActionSheetView delegate

- (void)openLibraryForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    self.imagePickerController = [ImagePickerController new];
    
    self.imagePickerController.delegate = self;
    self.imagePickerController.item = item;
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)makeANewPhotoForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    self.imagePickerController = [ImagePickerController new];
    
    self.imagePickerController.delegate = self;
    self.imagePickerController.item = item;
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                             UIIMAGEPICKERCONTROLLER DELEGATE                                 */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - UIImagePickerController delegate

// Styling
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[ImagePickerController class]] &&
        ((ImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
        navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Photo became saved later in dependence on
    // wether the User pressed the save or cancel button
    [self.tmpPhotoInfoArray addObject:info];
    [self.tmpImagePickerArray addObject:picker];
    
    // enable save Button...or not
    if (self.textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    // cancelButtonPressed make TextView to FirstResponder
    // This must become undone for fancy animation
    [self.textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        PhotoFeedbackView *photoFeedbackView = [PhotoFeedbackView new];
        photoFeedbackView.delegate = self;
        [self.navigationController.view addSubview:photoFeedbackView];
    }];
}

#pragma mark - UIImagePickerController Helper

- (void)savePhotoInDBWithInfo:(NSDictionary *)info {
    // Add Image to DB
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    NSData* data = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.9);
    photo.photoData = data;
    [self.imagePickerController.item addPhotosObject:photo];
    
    // Add Thumbnail to DB
    UIImage* thumbnail = [self generatThumbnailWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    photo.thumbData = UIImageJPEGRepresentation(thumbnail, 0.9);
    
    if (![self.appDelegate.managedObjectContext save:nil]) {
        NSLog(@"errorrrr");
    }
}

- (void)savePhotoInLibrary:(UIImagePickerController*)picker ForInfo:(NSDictionary*)info {
    // Save Photo in Image Library
    if (self.appDelegate.settings.savePhotos) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            CGImageRef imageRef = [[info objectForKey:UIImagePickerControllerOriginalImage] CGImage];
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
            NSString *albumName = @"Text&Colour";
            NSDictionary *metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
            
            [library saveImage:imageRef withMetadata:metaData inAlbum:albumName];
        }
    }
}

- (UIImage*)generatThumbnailWithImage:(UIImage*)image {
    // Crop Image
    int width = image.size.width;
    int height = (int)(18.51 * width) / 100;
    int y = (int)(image.size.height / 2) - (height / 2);
    UIImage *cropedImage = [self cropImage:image ToRect:CGRectMake(0, y, width, height)];
    
    // Scale Image
    UIImage* scaledImage = [self scaleImage:cropedImage ToSize:CGSizeMake(540, 100)];
    
    // Image Overlay
    UIImage* thumbnail = [self overlayImage:scaledImage WithImage:[UIImage imageNamed:@"thumbnailOverlay@2x"]];
    return thumbnail;
}

- (UIImage*)scaleImage:(UIImage*)image ToSize:(CGSize)size {
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

- (UIImage*)cropImage:(UIImage*)image ToRect:(CGRect)rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [image drawInRect:drawRect];
    
    // grab image
    UIImage* cropedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return cropedImage;
}

- (UIImage*)overlayImage:(UIImage*)image WithImage:(UIImage*)overlayImage {
    
	// size is taken from the background image
	UIGraphicsBeginImageContext(image.size);
    
	[image drawAtPoint:CGPointZero];
	[overlayImage drawAtPoint:CGPointZero];
    
	UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return combinedImage;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                 PHOTOFEEDBACKVIEW DELEGATE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - PhotoFeedbackView Delegate

- (void)photoFeedBackAnimationEnds {
    [self.textView becomeFirstResponder];
}

@end
