//
//  DropAndSwipeTableViewController.m
//  Text&Colour
//
//  Created by Lindemann on 29.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

/*----------------------------------------------------------------------------------------------*/

#import "SuperTableViewController.h"
#import "Item+BugFix.h"
#import "Item.h"
#import "OtherItemTableViewController.h"
#import "AddOrEditItemViewController.h"
#import "OtherItemTableViewController.h"
#import "FirstItemTableViewController.h"
#import "ColorConstants.h"
#import "Device.h"
#import "PhotoFeedbackView.h"
#import "Photo.h"
#import "ALAssetsLibrary+PhotoAlbum.h"

/*----------------------------------------------------------------------------------------------*/

typedef enum _OptionPanelState {
    HIDE = 0,
    SHOW = 1
} OptionPanelState;

typedef enum _SwipeState {
    CLOSED = 0,
    OPEN = 1
} SwipeState;

/*----------------------------------------------------------------------------------------------*/

@interface SuperTableViewController ()

@property (nonatomic, strong) NSIndexPath *selectedTableViewIndexPath;
@property (nonatomic) OptionPanelState optionPanelState;
@property (nonatomic) SwipeState swipeState;

@end

/*----------------------------------------------------------------------------------------------*/

@implementation SuperTableViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
    
/*                                            SETTER                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Setter

- (void) setOptionPanelState:(OptionPanelState)optionPanelState {
    _optionPanelState = optionPanelState;
    for (Item *item in self.data) {
        if (optionPanelState == HIDE) {
            item.optionPanelState = optionPanelState;
            [self.appDelegate saveContext];
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         LIFECYCLE                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Add ToolBar with "+"-Button
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *plus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addItem)];
    NSArray* toolbarItems = @[ flexibleSpace, plus, flexibleSpace ];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbarHidden = NO;
    // Solid Color
    self.navigationController.toolbar.backgroundColor = [UIColor colorWithRed:0.20f green:0.21f blue:0.21f alpha:1.00f];
    // Generate a transparet image which is necessary to give the toolbar a solid color
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.toolbar setBackgroundImage:transparentImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // Add Background image
    self.navigationController.view.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropTableViewBackground"]];
    
//    self.navigationController.view.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"graphPaperTableViewBackground"]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    // Hide SearchBar 
//    CGRect tableViewBounds = self.tableView.bounds;
//    tableViewBounds.origin.y += self.searchDisplayController.searchBar.bounds.size.height;
//    self.tableView.bounds = tableViewBounds;
    
    // StyleSearchbar
    UIImage *searchBarBackgroundImage = [[UIImage imageNamed:@"searchBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 2, 0)];
    self.searchDisplayController.searchBar.backgroundImage = searchBarBackgroundImage;
    [self.searchDisplayController.searchBar setScopeBarBackgroundImage:searchBarBackgroundImage];
    
//    UIImage *searchBarFieldBackgroundImage = [[UIImage imageNamed:@"searchBarFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *searchBarFieldBackgroundImage = [[UIImage imageNamed:@"searchBarFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:searchBarFieldBackgroundImage forState:UIControlStateNormal];
    
    // Add Subview over SearchBar
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, -300, 320, 300)];
    UIImage *searchBarSubViewImage = [[UIImage imageNamed:@"searchBarSubView"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:searchBarSubViewImage];
    imageView.frame = CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height);
    [subView addSubview:imageView];
    [self.tableView addSubview:subView];
    
    // Label
    [self addLable:@"WAT...NO REFRESH?!\n(╯°□°）╯︵ ┻━┻" ToSearchBarSubView:subView];
    
    // Cancel Button
    UIImage *searchBarButtonImage = [[UIImage imageNamed:@"searchBarButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 8, 2, 8)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:searchBarButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *highlightedSearchBarButtonImage = [[UIImage imageNamed:@"searchBarButton_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 8, 2, 8)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:highlightedSearchBarButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // Remove ScrollIndicators
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    // Style NavBar (undo the vertical aligning of title in AppDelegate)
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    // The NumberButton must become updated for the case that the count has changes...NO!!!
//    [self.tableView reloadData];
    
    // Set the Data back to filterdData and
    // Update the data for the given SearchTerm
    if (self.searchDisplayController.active == YES) {
        [self searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:self.searchDisplayController.searchBar.text];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.searchDisplayController.active == NO) {
        self.navigationController.toolbarHidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row inSection:[self sectionForItems]];
    UITableView *tableView = [self realTableView];
    [self hideOptionPanelInTableView:tableView atIndexPath:tmpIndexPath];
    [self closeAllOpenSwipeCells];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                  DATASOURCE DELEGATE                                         */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // the TableView has an additional row when the OptionPanel is shown
    if (self.optionPanelState == SHOW) {
        return self.data.count + 1;
    } else {
        return self.data.count;
    }
}

/*----------------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return the OptionPanel TableViewCell
    if (self.optionPanelState == SHOW && indexPath.row == self.selectedTableViewIndexPath.row + 1) {
        static NSString *CellIdentifier = @"DropCell";
        OptionPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[OptionPanelTableViewCell alloc] init];
        }
        NSIndexPath *swipeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        cell.aboveCellIndexPath = swipeCellIndexPath;
        cell.delegate = self;
        return cell;
    } else {
        // Return the SwipeCell
        // Reuse of Cells is deactivated
        SwipeTableViewCell *cell = [[SwipeTableViewCell alloc] init];
        
        if ([[self.data objectAtIndex:[[self indexPathOfRealSwipeCellInTableView:tableView atIndexPath:indexPath] row]] swipeState] == OPEN) {
            [cell performSelector:@selector(openCell)];
//            cell.button.enabled = NO;
        }
        
        cell.delegate = self;
        Item *item = [self.data objectAtIndex:[[self indexPathOfRealSwipeCellInTableView:tableView atIndexPath:indexPath] row]];
        cell.label.text = item.text;
        cell.color = item.color;
        cell.count = item.children.count;
        return cell;
    }
}

/*----------------------------------------------------------------------------------------------*/

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // Close the Cell after reordering
    
    // The Delay is needed for the case when the Cell become moved to the other end of the table
    // Because -closeAllOpenSwipeCells became invoked after the animation in the next Runloop
    [self performSelector:@selector(closeAllOpenSwipeCells) withObject:nil afterDelay:0.1];
    
    // Reorder the Data Array for correct display of the data
    Item *tmpItem = [self.data objectAtIndex:sourceIndexPath.row];
    Item *tmpParent = tmpItem.parent;
    [self.data removeObjectAtIndex:sourceIndexPath.row];
    [self.data insertObject:tmpItem atIndex:destinationIndexPath.row];
    
    // Reorder the real Data in the DB
    [tmpItem.parent removeChildrenObject:tmpItem];
    [tmpParent insertChildren:[NSArray arrayWithObject:tmpItem] atIndexes:[NSIndexSet indexSetWithIndex:destinationIndexPath.row]];
    // Update the indexes of the items in the DB
    for (Item *item in tmpParent.children) {
        item.index = [item.parent.children indexOfObject:item];
    }
    [self.appDelegate saveContext];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                     TABLEVIEW DELEGATE                                       */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *optionPanelIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    // Show OptionPanel when no Cell was selected befor
    if (self.optionPanelState == HIDE) {
        self.selectedTableViewIndexPath = indexPath;
        // important that SHOW is set here for -numberOfRowsInSection:... and -tableView:cellForRowAtIndexPath:
        self.optionPanelState = SHOW;
        
        // Set for one Cell/Data the OptionPanelState SHOW...needed in - hideOptionPanelInTableView: atIndexPath:
        [[self.data objectAtIndex:self.selectedTableViewIndexPath.row] setOptionPanelState:SHOW];

        // invoke animation and call - tableView:cellForRowAtIndexPath:
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];

        // Scrolls the TableView to new OptionCell if it is not visable
        UITableViewCell *optionCell = [tableView cellForRowAtIndexPath:optionPanelIndexPath];
        if (![tableView.visibleCells containsObject:optionCell]) {
            [tableView scrollToRowAtIndexPath:optionPanelIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    // Hide OptionPanel when same the Cell become selected
    else if (self.optionPanelState == SHOW && indexPath.row == self.selectedTableViewIndexPath.row) {
        // importent that HIDE is set here for - tableView:cellForRowAtIndexPath:
        self.optionPanelState = HIDE;
        // invoke animation and call - tableView:cellForRowAtIndexPath:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        // Unselect the double selected Cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedTableViewIndexPath];
        cell.selected = NO;
    }
    // Prevent from any action of the OptionPanel Cell
    else if (self.optionPanelState == SHOW && indexPath.row == self.selectedTableViewIndexPath.row + 1) {
        // SelectedTableViewCell become unselected throu the tap on the OptionPanel
        // ...that shoud not be happend...so select them back
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedTableViewIndexPath];
        cell.selected = YES;
        // Dropdown Cell Selected - No Action
        return;
    }
    // Another Cell became selected while the OptionPanel is still shown
    else if (self.optionPanelState == SHOW && indexPath.row != self.selectedTableViewIndexPath.row) {
        
        [tableView beginUpdates]; // Funny...like in OpenGL
        
        // +++++++++++ Remove the OptionPanel from the old Cell +++++++++++++++++
        
        // importent that HIDE is set here for - tableView:cellForRowAtIndexPath:
        self.optionPanelState = HIDE;
        // optionPanelIndexPath is not longer up to date...because the other Cell sets them new
        NSIndexPath *oldOptionPanelIndexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row + 1 inSection:indexPath.section];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:oldOptionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        // the old SelectedTableViewCell should not stay selected
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedTableViewIndexPath];
        cell.selected = NO; // ...hmmm dont get it?! O_o
        
        // ++++++++++++ Add the OptionPanel to the new Cell +++++++++++++++++++++
        
        // The IndexPath is incorrect, because the OptionPanelIndexPath
        // increase the indexPath with 1 when the selectedTableViewIndexPath is higher
        if (indexPath.row > self.selectedTableViewIndexPath.row) {
            self.selectedTableViewIndexPath = [NSIndexPath indexPathForRow:indexPath.row -1 inSection:indexPath.section];
            optionPanelIndexPath = indexPath;
        } else {
            self.selectedTableViewIndexPath = indexPath;
            // for optionPanelIndexPath look first line
        }
        self.optionPanelState = SHOW;
        
        // Set for one Cell/Data the OptionPanelState SHOW...needed in - hideOptionPanelInTableView: atIndexPath:
        [[self.data objectAtIndex:self.selectedTableViewIndexPath.row] setOptionPanelState:SHOW];
        
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [tableView endUpdates]; // Funny...but also creepy...
        
        // Scrolls the TableView to new OptionCell if it is not visable
        UITableViewCell *optionCell = [tableView cellForRowAtIndexPath:optionPanelIndexPath];
        if (![tableView.visibleCells containsObject:optionCell]) {
            [tableView scrollToRowAtIndexPath:optionPanelIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

/*----------------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.optionPanelState == SHOW && indexPath.row == self.selectedTableViewIndexPath.row + 1) {
        return 44;
    } else {
        return 80;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              SWIPETABLEVIEWCELL DELEGATE                                     */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - SwipeTableViewCell delegate

- (void)tableView:(UITableView *)tableView didPressButtonAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    OtherItemTableViewController *otherItemTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"OtherItemTableViewController"];
    otherItemTableViewController.parent = [self.data objectAtIndex:[[self indexPathOfRealSwipeCellInTableView:tableView atIndexPath:indexPath] row]];
    [self.navigationController pushViewController:otherItemTableViewController animated:YES];
}

- (void)prepareForOpenSwipeInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    // IndexPath is to high when an OptionPanel is visable
    // because the OptionPanels became removed in the next step
    NSIndexPath *realIndexPath = [self indexPathOfRealSwipeCellInTableView:tableView atIndexPath:indexPath];
    // Remove OptionPanels
    [self hideOptionPanelInTableView:tableView atIndexPath:indexPath];
    [[self.data objectAtIndex:[realIndexPath row]] setSwipeState:OPEN];
    self.editing = YES;
//    SwipeTableViewCell *cell = (SwipeTableViewCell*)[tableView cellForRowAtIndexPath:realIndexPath];
//    cell.button.enabled = NO;
    
    [self closeOpenSwipeCellsInTableView:tableView atIndexPath:realIndexPath];
}

- (void)prepareForCloseSwipeInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    [[self.data objectAtIndex:[[self indexPathOfRealSwipeCellInTableView:tableView atIndexPath:indexPath] row]] setSwipeState:CLOSED];
    self.editing = NO;
//    SwipeTableViewCell *cell = (SwipeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.button.enabled = YES;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                      LITTLE HELPER                                           */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Little Helper

// Hides all OptionPanels
- (void) hideOptionPanelInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    // IndexPath should become replaced by Section
    // because Row is not needed
    // Method should become renamed to
    // hideAllOptionPanelsInTableView:ForSection:
    for (int i = 0; i < self.data.count; ++i) {
        if ([[self.data objectAtIndex:i] optionPanelState] == SHOW) {
            self.optionPanelState = HIDE;
            NSIndexPath *optionPanelIndexPath = [NSIndexPath indexPathForRow:i + 1 inSection:indexPath.section];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:optionPanelIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            self.selectedTableViewIndexPath = nil;
            
            // All cells become after -viewWillLoad... unselected
            // In case these method wasn't invoked by -viewWillLoad... they are unselecded anyway
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            SwipeTableViewCell *cell = (SwipeTableViewCell*)[self.tableView cellForRowAtIndexPath:cellIndexPath];
            cell.selected = NO;
            
            [self.appDelegate saveContext];
        }
    }
}

// Closes all open Cells exept the one which was open with prepareForOpenSwipeInTableView:...
- (void)closeOpenSwipeCellsInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    for (int i = 0; i < self.data.count; ++i) {
        if ([[self.data objectAtIndex:i] swipeState] == OPEN && i != indexPath.row) {
            NSIndexPath *closeIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            SwipeTableViewCell *cell = (SwipeTableViewCell*)[tableView cellForRowAtIndexPath:closeIndexPath];
            [cell performSelector:@selector(closeCell) withObject:nil afterDelay:0.2];
            [[self.data objectAtIndex:closeIndexPath.row] setSwipeState:CLOSED];
//            cell.button.enabled = YES;
        }
    }
}

// Used in -viewWillLoad... and -moveRowAtIndexPath:...
// Closes realy all open cells and disables editing
- (void) closeAllOpenSwipeCells {
    for (int i = 0; i < self.data.count; ++i) {
        if ([[self.data objectAtIndex:i] swipeState] == OPEN) {
            NSIndexPath *closeIndexPath = [NSIndexPath indexPathForRow:i inSection:[self sectionForItems]];
            SwipeTableViewCell *cell = (SwipeTableViewCell*)[self.tableView cellForRowAtIndexPath:closeIndexPath];
            [cell performSelector:@selector(closeCell) withObject:nil afterDelay:0.2];
            [[self.data objectAtIndex:i] setSwipeState:CLOSED];
//            cell.button.enabled = YES;
            self.editing = NO;
            
            [self.appDelegate saveContext];
        }
    }
}

// In case the anoying OptionPanel is shown and I need the correct indexPath of the SwipeCell
- (NSIndexPath*)indexPathOfRealSwipeCellInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    if (self.optionPanelState == SHOW && self.selectedTableViewIndexPath.row < indexPath.row) {
        NSIndexPath *swipeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        return swipeCellIndexPath;
    } else {
        return indexPath;
    }
}

// Return the correct Section for the TableViewController
- (int)sectionForItems {
    if ([self isKindOfClass:[OtherItemTableViewController class]] && self.searchDisplayController.active == NO) {
        return 1;
    } else {
        return 0;
    }
}

// Return the correct TableView
-(UITableView*)realTableView {
    if ([self.searchDisplayController isActive]) {
        return self.searchDisplayController.searchResultsTableView;
    } else {
        return self.tableView;
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                            OPTIONPANELTABLEVIEWCELL DELEGATE                                 */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - OptionPanelTableViewCell delegate

- (void)chooseColorInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
    
    ColorActionSheetView *customActionSheetView = [[ColorActionSheetView alloc] init];
    
    // Creepy Issue...without that step the View would beginn behind the Statusbar
    if ([Device resolution] == IPHONE_LONG) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
    }
    if ([Device resolution] == IPHONE_SHORT) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
    }
    
    customActionSheetView.item = [self.data objectAtIndex:swipeCellIndexPath.row];
    customActionSheetView.delegate = self;
    [self.navigationController.view addSubview:customActionSheetView];
    
    if (self.searchDisplayController.active == YES) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

- (void)editItemInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
    
    if (self.searchDisplayController.active == YES) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
    
    UINavigationController* navigationController = [UINavigationController new];
    AddOrEditItemViewController *addOrEditItemViewController = [AddOrEditItemViewController new];
    [navigationController pushViewController:addOrEditItemViewController animated:NO];
    addOrEditItemViewController.mode = EDITMODE;
    Item *item = [self.data objectAtIndex:swipeCellIndexPath.row];
    addOrEditItemViewController.currentItem = item;
    [self presentViewController:navigationController animated:YES completion:nil];
    addOrEditItemViewController.textView.text = item.text;
}

- (void)addPhotoInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
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
    customActionSheetView.item = [self.data objectAtIndex:swipeCellIndexPath.row];
    customActionSheetView.tableView = tableView;
    customActionSheetView.swipeCellIndexPath = swipeCellIndexPath;
    
    [self.navigationController.view addSubview:customActionSheetView];
    
    if (self.searchDisplayController.active == YES) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

- (void)deleteItemInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
    
    DeleteItemActionSheetView *customActionSheetView = [[DeleteItemActionSheetView alloc] init];
    
    // Creepy Issue...without that step the View would beginn behind the Statusbar
    if ([Device resolution] == IPHONE_LONG) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 548);
    }
    if ([Device resolution] == IPHONE_SHORT) {
        customActionSheetView.frame = CGRectMake(0, 20, 320, 460);
    }
    
    customActionSheetView.delegate = self;
    customActionSheetView.tableView = tableView;
    customActionSheetView.swipeCellIndexPath = swipeCellIndexPath;
    [self.navigationController.view addSubview:customActionSheetView];
    
    if (self.searchDisplayController.active == YES) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                               DELETEITEMACTIONSHEET DELEGATE                                 */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - DeleteItemActionSheetView delegate

- (void)deletItemButtonPressedInTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    [tableView beginUpdates];
    [self hideOptionPanelInTableView:tableView atIndexPath:swipeCellIndexPath];
    
    Item *tmpItem = [self.data objectAtIndex:swipeCellIndexPath.row];
    Item *tmpParent = tmpItem.parent;
    
    // Remove the item in the Array for correct display of the data
    [self.data removeObjectAtIndex:swipeCellIndexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipeCellIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [tableView endUpdates];
    
    // Remove the real Data in the DB
    [self.appDelegate.managedObjectContext deleteObject:tmpItem];
    // Update the indexes of the items in the DB
    for (Item *item in tmpParent.children) {
        item.index = [item.parent.children indexOfObject:item];
    }
    
    [self.appDelegate saveContext];
    
//    // Item
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
//    NSSortDescriptor *sortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
//    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
//    for (Item *item in array) {
//        NSLog(@"parent %@ text %@",item.parent.text, item.text);
//    }
//    
//    // Photos
//    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
//    NSArray* arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
//    for (Photo* _phone in arr) {
//        NSLog(@"Photo %@", _phone.objectID);
//    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              COLORACTIONSHEETVIEW DELEGATE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - ColorActionSheetView delegate

- (void)cancelButtonPressed {
    
}

- (void)blueButtonPressedForItem:(Item*)item {
    item.color = BLUE;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

- (void)yellowButtonPressedForItem:(Item*)item {
    item.color = YELLOW;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

- (void)turquoiseButtonPressedForItem:(Item*)item {
    item.color = TURQUOISE;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

- (void)grayButtonPressedForItem:(Item*)item {
    item.color = GRAY;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

- (void)roseButtonPressedForItem:(Item*)item {
    item.color = ROSE;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

- (void)coralButtonPressedForItem:(Item*)item {
    item.color = CORAL;
    [self.appDelegate saveContext];
    UITableView *tableView = [self realTableView];
    [tableView reloadData];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                              PHOTOACTIONSHEETVIEW DELEGATE                                   */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - PhotoActionSheetView delegate

- (void)openLibraryForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    self.imagePickerController = [ImagePickerController new];
    
    self.imagePickerController.delegate = self;
    self.imagePickerController.item = item;
    self.imagePickerController.tableView = tableView;
    self.imagePickerController.swipeCellIndexPath = swipeCellIndexPath;
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)makeANewPhotoForItem:(Item*)item InTableView:(UITableView*)tableView atSwipeCellIndexPath:(NSIndexPath*)swipeCellIndexPath {
    self.imagePickerController = [ImagePickerController new];
    
    self.imagePickerController.delegate = self;
    self.imagePickerController.item = item;
    self.imagePickerController.tableView = tableView;
    self.imagePickerController.swipeCellIndexPath = swipeCellIndexPath;
    
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
    
    dispatch_queue_t loadData = dispatch_queue_create("loadData", NULL);
    dispatch_async(loadData, ^{
        
        [self savePhotoInDBWithInfo:info];
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:^{
                PhotoFeedbackView *photoFeedbackView = [PhotoFeedbackView new];
                [self.navigationController.view addSubview:photoFeedbackView];
            }];
            
        });
    });
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

- (UIImage*)generatThumbnailWithImage:(UIImage*)image {
    // Crop Image
    int width = image.size.width;
    // thumbnailHeight = 100, thumbnailWidth = 540 (retina)
    // (100 * 100) / 540 = 18.51
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

/*                                          STYLING                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Styling

- (void)addLable:(NSString*)string ToSearchBarSubView:(UIView*)subView {
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 255, 280, 30)];
    label.center = CGPointMake(subView.center.x, label.center.y);
    label.numberOfLines = 2;
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Arial" size:10];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.61f green:0.64f blue:0.65f alpha:1.00f];
    label.shadowColor = [UIColor colorWithRed:0.85f green:0.89f blue:0.92f alpha:1.00f];
    label.shadowOffset = CGSizeMake(0, 1);
    [subView addSubview:label];
}


/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           SEARCH                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // Get the right indexPath to clear the TableView when Search begins
    if (![self.searchDisplayController isActive]) {
        NSIndexPath *indexPath = nil;
        if ([self isKindOfClass:[OtherItemTableViewController class]]) {
            // hideOptionPanelInTableView: in OtherItemTableViewController
            // changes the IndexPath if the OptionCell in Section 0 is open
            indexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row inSection:1];
        } else {
            indexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row inSection:0];
        }
        
        [self hideOptionPanelInTableView:self.tableView atIndexPath:indexPath];
        [self closeAllOpenSwipeCells];
    }
    
    // Creepy Bug...should be invoked in -didLoadSearchResultsTableView:... but must become invoked here
    self.navigationController.toolbarHidden = YES;
    
    // If Optionpanel is open in searchResultsTableView
    // Prevent Crashing
    if ([self.searchDisplayController isActive]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row inSection:0];
        [self hideOptionPanelInTableView:self.searchDisplayController.searchResultsTableView atIndexPath:indexPath];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // If Optionpanel is open in searchResultsTableView
    // Prevent Crashing
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedTableViewIndexPath.row inSection:0];
    [self hideOptionPanelInTableView:self.searchDisplayController.searchResultsTableView atIndexPath:indexPath];
}

// Cancel Search
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if ([self.searchDisplayController isActive]) {
        self.navigationController.toolbarHidden = YES;
    } else {
       self.navigationController.toolbarHidden = NO; 
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    // 1
//#warning creepy Bug
//    self.navigationController.toolbarHidden = YES;
    
    // Style SearchTableView
    tableView.rowHeight = 80;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    // Add Background image 
    UIView *backgroundView = [UIImageView new];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropTableViewBackground"]];
    controller.searchResultsTableView.backgroundView = backgroundView;
    
    // Add Subview over SearchBar
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, -300, 320, 300)];
    UIImage *searchBarSubViewImage = [[UIImage imageNamed:@"searchBarSubView"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:searchBarSubViewImage];
    imageView.frame = CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height);
    [subView addSubview:imageView];
    [tableView addSubview:subView];
    
    // TRUE LOVE WILL FIND YOU IN THE END
    [self addLable:@"DID YOU FIND WHAT YOU'RE LOOKING FOR?\n◕ ◡ ◕" ToSearchBarSubView:subView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    // U3
    self.optionPanelState = HIDE;
    self.navigationController.toolbarHidden = NO;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    // 3
    self.appDelegate.searchDisplayControllerIsActive = self.appDelegate.searchDisplayControllerIsActive + 1;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    // 4
    
    [self findAndHideSearchBarShadowInView:tableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    // U1
    self.appDelegate.searchDisplayControllerIsActive = self.appDelegate.searchDisplayControllerIsActive - 1;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    // U2
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // 2
    [self filterContentForSearchText:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText {
    /*
	 Update the filtered array based on the search text and scope.
	 */
	self.data = [NSMutableArray new]; // First clear the filtered array.
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSSortDescriptor *sortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    for (Item *item in array) {
        if ([item.text rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            if (item.text != nil) {
                [self.data addObject:item];
            }
        }
    }
}

// Hides the anoying shadow in the SearchDisplayController under the SearchBar
// Source: http://stackoverflow.com/q/13634319/647644
- (void)findAndHideSearchBarShadowInView:(UIView *)view {
    NSString *usc = @"_";
    NSString *sb = @"UISearchBar";
    NSString *sv = @"ShadowView";
    NSString *s = [[usc stringByAppendingString:sb] stringByAppendingString:sv];
    
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:NSClassFromString(s)]) {
            v.alpha = 0.0f;
        }
        [self findAndHideSearchBarShadowInView:v];
    }
}

@end
