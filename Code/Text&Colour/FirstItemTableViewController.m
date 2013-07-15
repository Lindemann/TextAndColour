//
//  ItemTableViewController.m
//  Text&Colour
//
//  Created by Judith Lindemann on 08.06.12.
//  Copyright (c) 2012 LINDEMANN. All rights reserved.
//

#import "FirstItemTableViewController.h"
#import "AddOrEditItemViewController.h"
#import "Item+BugFix.h"
#import "OtherItemTableViewController.h"

/*----------------------------------------------------------------------------------------------*/

@interface FirstItemTableViewController ()

@property (strong, nonatomic) Item *rootParent;
@property (nonatomic, strong) NSMutableArray *items;

@end

/*----------------------------------------------------------------------------------------------*/

@implementation FirstItemTableViewController

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         CORE DATA                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Core Data

- (Item*)rootParent {
    if (!_rootParent) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        NSPredicate *predacate = [NSPredicate predicateWithFormat:@"parent == NIL"];
        fetchRequest.predicate = predacate;
        NSArray* array = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if (array.count > 0) {
            _rootParent = [array objectAtIndex:0];
        } else {
            Item *rootParent = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.appDelegate.managedObjectContext];
            [self.appDelegate saveContext];
            _rootParent = rootParent;
        }
        return _rootParent;
    } else {
        return _rootParent;
    }
}

- (void)updateItems {
    if (self.searchDisplayController.active == NO) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        NSSortDescriptor *sortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
        NSPredicate *predacate = [NSPredicate predicateWithFormat:@"parent == %@", self.rootParent];
        fetchRequest.predicate = predacate;
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
        
        self.items = [NSMutableArray arrayWithArray:[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
        
        // give the SwipeTableViewController the current datasource
        [super setData:self.items];
        
        [self.tableView reloadData];
    }
}

- (void)addItem {
    UINavigationController* navigationController = [UINavigationController new];
    AddOrEditItemViewController *addOrEditItemViewController = [AddOrEditItemViewController new];
    [navigationController pushViewController:addOrEditItemViewController animated:NO];
    addOrEditItemViewController.mode = ADDMODE;
    addOrEditItemViewController.parent = self.rootParent;
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
    
    self.title = @"Text&Colour";
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    // Loads the rootParent from the DB
    // or initialize a new one if the application became started the first time
    [self rootParent];
    // Loads Data into the items Array or updats it
    [self updateItems];
    
    // Add Drop to NavigationBar
    UIButton *dropButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 36)];
    [dropButton setBackgroundImage:[UIImage imageNamed:@"navBarDrop"] forState:UIControlStateNormal];
    [dropButton setBackgroundImage:[UIImage imageNamed:@"navBarDrop_highlighted"] forState:UIControlStateHighlighted];
    [dropButton addTarget:self action:@selector(dropButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    UIView *titleSubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dropButton.frame.size.width, dropButton.frame.size.height + 2)];
    [titleSubView addSubview:dropButton];
    [self.navigationItem setTitleView:titleSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *navBarBackgroundImage = [[UIImage imageNamed:@"firstItemTableViewNavBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 7, 2, 7)];
    [self.navigationController.navigationBar setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    if (self.searchDisplayController.active == NO) {
        [self updateItems];
    }
    [super viewWillAppear:animated];
}
/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                 DROPBUTTON TARGET                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - DropButton Target

- (void)dropButtonWasPressed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UINavigationController *settingsNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
    [self.navigationController presentViewController:settingsNavigationController animated:YES completion:nil];
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
