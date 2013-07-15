//
//  OtherItemTableViewController.m
//  Text&Colour
//
//  Created by Judith Lindemann on 10.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "OtherItemTableViewController.h"
#import "AddOrEditItemViewController.h"
#import "TextFieldTableViewCell.h"
#import "OptionPanelTableViewCell.h"
#import "Device.h"
#import "FirstItemTableViewController.h"
#import "PhotoFeedbackView.h"
#import "PageViewController.h"

/*----------------------------------------------------------------------------------------------*/

typedef enum _TextFieldOptionPanelState {
    HIDE = 0,
    SHOW = 1
} TextFieldOptionPanelState;

/*----------------------------------------------------------------------------------------------*/

@interface OtherItemTableViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) TextFieldOptionPanelState textFieldOptionPanelState;
@property (nonatomic) int textFieldCellHeight;
@property (nonatomic, strong) NavigationScrollView *navigationScrollView;

@end

/*----------------------------------------------------------------------------------------------*/

@implementation OtherItemTableViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         CORE DATA                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Core Data

- (void)updateItems {
    if (self.searchDisplayController.active == NO) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        NSSortDescriptor *sortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
        NSPredicate *predacate = [NSPredicate predicateWithFormat:@"parent == %@", self.parent];
        fetchRequest.predicate = predacate;
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
        
        self.items = [NSMutableArray arrayWithArray:[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
        
        // give the SwipeTableViewController the current datasource
        [super setData:self.items];
        
        [self calculateHeightForTextFieldTableViewCell];
        
        [self.tableView reloadData];
        
        // Check if self.parent still exist in DB
        // self.parent can become deleted in SearchDisplayController
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        predacate = [NSPredicate predicateWithFormat:@"self == %@", self.parent];
        fetchRequest.predicate = predacate;
        fetchRequest.sortDescriptors = nil;
        NSArray *arr = self.items = [NSMutableArray arrayWithArray:[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
        if (arr.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)addItem {
    UINavigationController* navigationController = [UINavigationController new];
    AddOrEditItemViewController *addOrEditItemViewController = [AddOrEditItemViewController new];
    [navigationController pushViewController:addOrEditItemViewController animated:NO];
    addOrEditItemViewController.mode = ADDMODE;
    addOrEditItemViewController.parent = self.parent;
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    // Add Toolbar
    [super viewDidLoad];
    
    self.title = self.parent.text;
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    // Loads Data into the items Array or updats it
    [self updateItems];
    
    // Add NavigationScrollView
    self.navigationScrollView = [[NavigationScrollView alloc] init];
    self.navigationScrollView.subView2.label.text = self.parent.text;
    self.navigationScrollView.subView1.label.text = self.parent.parent.text;
    self.navigationScrollView.navigationScrollViewProtocoldelegate = self;
    
    // if previous ViewController is the FirstItemTableViewController set the Drop image instead of title
    if (self.parent.parent.parent == nil) {
        self.navigationScrollView.subView1.imageVew.image = [UIImage imageNamed:@"navBarDrop"];
    }
    // if previous ViewController is a SearchDisplyController set a magnifier icon instead of title or Drop icon
    if ([[[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] searchDisplayController] isActive]) {
        UIImage *magnifierImage = [UIImage imageNamed:@"navBarMagnifier"];
        self.navigationScrollView.subView1.imageVew.frame = CGRectMake(self.navigationScrollView.subView1.imageVew.frame.origin.x, self.navigationScrollView.subView1.imageVew.frame.origin.y, magnifierImage.size.width, magnifierImage.size.height);
        self.navigationScrollView.subView1.imageVew.center = self.navigationScrollView.subView1.center;
        self.navigationScrollView.subView1.imageVew.image = magnifierImage;
        
        self.navigationScrollView.subView1.label.text = nil;
    }

    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationItem setTitleView:self.navigationScrollView];
    
    // TextFieldTableViewCell Height
    [self calculateHeightForTextFieldTableViewCell];
    
    // Add Buttons to NavigationBar
    // Drop or Magnifier
    UIButton *leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 41)];
    if (!self.appDelegate.searchDisplayControllerIsActive) {
        [leftItemButton setBackgroundImage:[UIImage imageNamed:@"navBarDropButton"] forState:UIControlStateNormal];
        [leftItemButton setBackgroundImage:[UIImage imageNamed:@"navBarDropButton_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [leftItemButton setBackgroundImage:[UIImage imageNamed:@"navBarMagnifierButton"] forState:UIControlStateNormal];
        [leftItemButton setBackgroundImage:[UIImage imageNamed:@"navBarMagnifierButton_highlighted"] forState:UIControlStateHighlighted];
    }
    [leftItemButton addTarget:self action:@selector(goToFirstItemTableViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIImage *image = [[UIImage imageNamed:@"otherItemTableViewNavBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 76, 2, 4)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    if (self.searchDisplayController.active == NO) {
        [self updateItems];
    }
    self.navigationScrollView.subView2.label.text = self.parent.text;
    [super viewWillAppear:animated];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                        DATASOURCE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchDisplayController.active == YES) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.searchDisplayController.active == NO) {
        if (self.textFieldOptionPanelState == SHOW) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.searchDisplayController.active == NO) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"Detail";
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TextFieldTableViewCell alloc] init];
            }
            // Must become set befor cell.item 
            cell.photoButtonDelegate = self;
            
            cell.item = self.parent;
            cell.backgroundImageView.frame = CGRectMake(cell.backgroundImageView.frame.origin.x, cell.backgroundImageView.frame.origin.y, cell.backgroundImageView.frame.size.width, self.textFieldCellHeight);
            
            return cell;
        } else {
            static NSString *CellIdentifier = @"DropCell";
            OptionPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[OptionPanelTableViewCell alloc] init];
            }
            NSIndexPath *aboveCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            cell.aboveCellIndexPath = aboveCellIndexPath;
            cell.delegate = self;
            return cell;
        }
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

/*----------------------------------------------------------------------------------------------*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || self.searchDisplayController.active == YES) {
        return NO;
    } else {
        return YES;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                     TABLEVIEW DELEGATE                                       */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *optionPanelIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *textFieldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (indexPath.section == 0 && self.searchDisplayController.active == NO) {
        if (self.textFieldOptionPanelState == HIDE) {
            
            [tableView beginUpdates];
            
            // Hide at first all shown OptionPanels in Section 1
            NSIndexPath *sectionOneIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            [self hideOptionPanelInTableView:tableView atIndexPath:sectionOneIndexPath];
            
            self.textFieldOptionPanelState = SHOW;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            [tableView endUpdates];
            
            // Scrolls the TableView to new OptionCell if it is not visable
            UITableViewCell *optionCell = [tableView cellForRowAtIndexPath:optionPanelIndexPath];
            if (![tableView.visibleCells containsObject:optionCell]) {
                [tableView scrollToRowAtIndexPath:optionPanelIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else if (self.textFieldOptionPanelState == SHOW && [indexPath isEqual:textFieldIndexPath] ) {
            self.textFieldOptionPanelState = HIDE;
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:textFieldIndexPath];
            cell.selected = NO;
        }
        else if (self.textFieldOptionPanelState == SHOW && [indexPath isEqual:optionPanelIndexPath]) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:textFieldIndexPath];
            cell.selected = NO;
            
            return;
        }
    } else {
        if (self.textFieldOptionPanelState == SHOW && indexPath.section == 1 && self.searchDisplayController.active == NO) {
            self.textFieldOptionPanelState = HIDE;
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:textFieldIndexPath];
            cell.selected = NO;
        }
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.searchDisplayController.active == NO) {
        if (indexPath.row == 0) {
            return self.textFieldCellHeight;
        } else {
            return 44;
        }
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                      LITTLE HELPER                                           */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Little Helper

- (void)calculateHeightForTextFieldTableViewCell {
    // Find out the Size of the TextFieldTableViewCell Label
    // becaue it is needed in -heightForCellAtIndexPath...
    // which is called befor -cellForRowAtIndexPath:...
    
    // Fake Label can contain some useless lines of code 
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 0)];
    tmpLabel.text = self.parent.text;
    tmpLabel.font = [UIFont systemFontOfSize:17];
    tmpLabel.minimumScaleFactor = 0;
//    tmpLabel.adjustsFontSizeToFitWidth = NO;
    tmpLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    tmpLabel.textAlignment =  UITextAlignmentLeft;
    tmpLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    tmpLabel.numberOfLines = 0;
    tmpLabel.shadowColor = [UIColor whiteColor];
    tmpLabel.shadowOffset = CGSizeMake(0,1);
    [tmpLabel sizeToFit];
    
    int photoButtonsHeight = 0;
    int someExtraPixel = 0;
    
    // If Item has Photos
    for (int i = 0; i < self.parent.photos.count; ++i) {
        photoButtonsHeight += 81;
        someExtraPixel = 0;
    }
    
    int textFieldCellMargin = 27;
    self.textFieldCellHeight = tmpLabel.frame.size.height + textFieldCellMargin + photoButtonsHeight + someExtraPixel;
}

- (void) hideOptionPanelInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    if (self.textFieldOptionPanelState == SHOW && self.searchDisplayController.active == NO) {
        NSIndexPath *optionPanelIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        self.textFieldOptionPanelState = HIDE;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.appDelegate saveContext];
    } else {
        [super hideOptionPanelInTableView:tableView atIndexPath:indexPath];
    }
}

- (void)goToFirstItemTableViewController {
    for (int i = self.navigationController.viewControllers.count - 2 ; i >= 0; --i) {
        UIViewController *controler = [self.navigationController.viewControllers objectAtIndex:i];
        if (controler.searchDisplayController.active == YES) {
            [self.navigationController popToViewController:controler animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                 NAVIGATIONSCROLLVIEW DELEGATE                                */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - NavigationScrollView delegate

-(void)navigationScrollViewWasSwiped {
    [self.navigationController popViewControllerAnimated:YES];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                            OPTIONPANELTABLEVIEWCELL DELEGATE                                 */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - OptionPanelTableViewCell delegate

- (void)chooseColorInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
        
        ColorActionSheetView *customActionSheetView = [[ColorActionSheetView alloc] init];
        // Creepy Issue...without that step the View would beginn behind the Statusbar
        if ([Device resolution] == IPHONE_LONG) {
            customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
        }
        if ([Device resolution] == IPHONE_SHORT) {
            customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
        }

        customActionSheetView.item = self.parent;
        customActionSheetView.delegate = self;
        
        [self.navigationController.view addSubview:customActionSheetView];
    } else {
        [super chooseColorInTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}

- (void)editItemInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        UINavigationController* navigationController = [UINavigationController new];
        AddOrEditItemViewController *addOrEditItemViewController = [AddOrEditItemViewController new];
        [navigationController pushViewController:addOrEditItemViewController animated:NO];
        addOrEditItemViewController.mode = EDITMODE;
        Item *item = self.parent;
        addOrEditItemViewController.currentItem = item;
        [self presentViewController:navigationController animated:YES completion:nil];
        addOrEditItemViewController.textView.text = item.text;
    } else {
        [super editItemInTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}

- (void)addPhotoInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
        
        PhotoActionSheetView *customActionSheetView = [[PhotoActionSheetView alloc] init];
        // Creepy Issue...without that step the View would beginn behind the Statusbar
        if ([Device resolution] == IPHONE_LONG) {
            customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
        }
        if ([Device resolution] == IPHONE_SHORT) {
            customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
        }
        
        customActionSheetView.delegate = self;
        customActionSheetView.item = self.parent;
        customActionSheetView.tableView = tableView;
        customActionSheetView.swipeCellIndexPath = swipeCellIndexPath;
        
        [self.navigationController.view addSubview:customActionSheetView];
    } else {
        [super addPhotoInTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}


/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                DELETEACTIONSHEET DELEGATE                                    */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - DeleteActionView delegate

- (void)deletItemButtonPressedInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        Item *tmpItem = self.parent;
        Item *tmpParent = tmpItem.parent.parent;
        // Remove the real Data in the DB
        [self.appDelegate.managedObjectContext deleteObject:tmpItem];
        // Update the indexes of the items in the DB
        for (Item *item in tmpParent.children) {
            item.index = [item.parent.children indexOfObject:item];
        }
        [self.appDelegate saveContext];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [super deletItemButtonPressedInTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              PHOTOACTIONSHEETVIEW DELEGATE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - PhotoActionSheetView delegate

- (void)openLibraryForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        self.imagePickerController = [ImagePickerController new];
        
        self.imagePickerController.delegate = self;
        self.imagePickerController.item = self.parent;
        self.imagePickerController.tableView = tableView;
        self.imagePickerController.swipeCellIndexPath = swipeCellIndexPath;
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [super openLibraryForItem:item InTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}

- (void)makeANewPhotoForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    if (swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
        self.imagePickerController = [ImagePickerController new];
        
        self.imagePickerController.delegate = self;
        self.imagePickerController.item = self.parent;
        self.imagePickerController.tableView = tableView;
        self.imagePickerController.swipeCellIndexPath = swipeCellIndexPath;
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [super makeANewPhotoForItem:item InTableView:tableView atSwipeCellIndexPath:swipeCellIndexPath];
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                             UIIMAGEPICKERCONTROLLER DELEGATE                                 */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - UIImagePickerController delegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    if (self.imagePickerController.swipeCellIndexPath.section == 0 && self.searchDisplayController.active == NO) {
//        
//        [self savePhotoInDBWithInfo:info];
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//            PhotoFeedbackView *photoFeedbackView = [PhotoFeedbackView new];
//            [self.navigationController.view addSubview:photoFeedbackView];
//            
//            // Rezise TextFieldCell
//        }];
//    } else {
//        [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
//    }
//}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                      PHOTOBUTTON DELEGATE                                    */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Photobutton Delegate

- (void)thumbnailButtonWasPressedAtIndex:(int)index ForItem:(Item*)item {
    // hideOptionPanelInTableView: finds out by his own whether the OptionPanel of TextDetailCell is shown...
    // If this is not the case the OptionPanels in Section 1 became removed
    [self hideOptionPanelInTableView:self.tableView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    UINavigationController* navigationController = [UINavigationController new];
    
    PageViewController *pageViewController = [[PageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{ UIPageViewControllerOptionInterPageSpacingKey : @20.f }];
    pageViewController.photoIndex = index;
    pageViewController.item = item;
    
    
    [navigationController pushViewController:pageViewController animated:NO];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           SEARCH                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Search

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    [super searchDisplayController:controller willUnloadSearchResultsTableView:tableView];
    [self updateItems];
}

@end
