//
//  ProjectTasksViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectTasksViewController.h"
#import "ProjectTasksDetailViewController.h"
#import "CoreDataController.h"
#import "Project.h"
#import "Task.h"
#import "AppDelegate.h"

@interface ProjectTasksViewController ()

@property (strong, nonatomic) CoreDataController* taskController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ProjectTasksViewController

{
    
    NSIndexPath* _showDeletedButton;
    NSArray* _formatValuesDisabled;
    NSArray* _formatValuesEnabled;
    NSArray* _formatKeys;
    NSDictionary* _disabledButtonTextFormat;
    NSDictionary* _enabledButtonTextFormat;
    
}

@synthesize hierarchyController = _hierarchyController;
@synthesize detailViewController = _detailViewController;
@synthesize selectedTask = _selectedTask;
//@synthesize splitViewController = _splitViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //view details
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    _formatKeys = [NSArray arrayWithObjects:UITextAttributeTextColor, UITextAttributeTextShadowColor, UITextAttributeFont, nil];
    _formatValuesDisabled = [NSArray arrayWithObjects:[UIColor lightGrayColor],[UIColor whiteColor],[UIFont fontWithName:@"Helvetica-Bold" size:16],nil];
    _formatValuesEnabled = [NSArray arrayWithObjects:[UIColor darkGrayColor],[UIColor clearColor], [UIFont fontWithName:@"Helvetica-Bold" size:16],nil];
    _disabledButtonTextFormat = [NSDictionary dictionaryWithObjects:_formatValuesDisabled forKeys:_formatKeys];
    _enabledButtonTextFormat = [NSDictionary dictionaryWithObjects:_formatValuesEnabled forKeys:_formatKeys];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"ProjectTasksViewController viewWillAppear called.");
    [super viewWillAppear:animated];
    
    self.detailViewController = (ProjectTasksDetailViewController *)[self.splitViewController.viewControllers lastObject];
    [self.hierarchyController setTitleTextAttributes:_disabledButtonTextFormat forState:UIControlStateDisabled];
    [self.hierarchyController setTitleTextAttributes:_enabledButtonTextFormat forState:UIControlStateNormal];
    
    NSLog(@"The tasks details view controller is %@",[self.detailViewController class]);
    
    
    NSLog(@"Our table has %d sections and %d rows in the first section.", [self.tableView numberOfSections], [self.tableView numberOfRowsInSection:0]);
    
    if ([self.tableView indexPathForSelectedRow]) {
        
        self.selectedTask = (Task*)[self.taskController objectInListAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        self.detailViewController.detailItem = self.selectedTask;
        
    } else {
        
        //no item selected, select top item
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        //call didSelectRowAtIndexPath, as it's not called when selection is made prgrammatically
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }
}


- (void)viewDidUnload
{
    [self setHierarchyController:nil];
    [self setHierarchyController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.taskController numberOfSections];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskController numberOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    if ([((Task*)[self.taskController objectAtIndexPath:indexPath]).wbs isEqualToString:@"1"])
    {  return NO; }
    else
    {  return YES; }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task* deleteTask = (Task*)[self.taskController objectAtIndexPath:indexPath];
        
        //before we delete the task, we determine the object to highlight after the delete
        Task* highlightTask = (Task*)[self.taskController objectFollowing:deleteTask];
        
        if ([highlightTask.wbs isEqualToString:deleteTask.wbs]) {
            
            //there was no object following the delete object, so the path of the delete object was returned instead
            //which means that the delete object is the last in the table and we should thus highlight the preceding task
            highlightTask = (Task*)[self.taskController objectPreceding:deleteTask];
            
        }
        
        //update other tasks' WBS entries
        [deleteTask reorderForDelete];
        
        if ([self.taskController deleteObject:deleteTask]) {
            
            //handle error
            abort();
        }

        [[self tableView] reloadData];
        
        NSIndexPath* newIndexPath = [self.taskController indexPathOfObject:highlightTask];
        [self.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tableView didSelectRowAtIndexPath:newIndexPath];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:_showDeletedButton]) {
        
        NSLog(@"Looks like the delete button was pressed for row %d in section %d", indexPath.row, indexPath.section);
        _showDeletedButton = nil;
        return UITableViewCellEditingStyleDelete;
        
    } else {
        
        return UITableViewCellEditingStyleNone;
        
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task* selectedTask = (Task*)[self.taskController objectAtIndexPath:indexPath];
    //setting the detail view object
    self.detailViewController.detailItem = selectedTask;
    self.selectedTask = selectedTask;
    
    //managing the hierarchy buttons

    NSLog(@"HierarchyController is of class %@", [self.hierarchyController class]);
    
    //unindent first
    if (selectedTask.level>2) {
        NSLog(@"The left segment of the segmented control should now be enabled.");
        [self.hierarchyController setEnabled:YES forSegmentAtIndex:0];
        
    } else {
        NSLog(@"The left segment of the segmented control should now be disabled.");
        [self.hierarchyController setEnabled:NO forSegmentAtIndex:0];
        [self.hierarchyController setBackgroundColor:[UIColor darkGrayColor]];
    }

    //indent next
    if ((selectedTask.isFirstChild) || (selectedTask.level==20)) {
        NSLog(@"The right segment of the segmented control should now be disabled.");
        [self.hierarchyController setEnabled:NO forSegmentAtIndex:1];
    } else {
        NSLog(@"We have selected task %@ and it is not a first child: %@", selectedTask.formattedWbs, (selectedTask.isFirstChild)?@"YES":@"NOPE");
        [self.hierarchyController setEnabled:YES forSegmentAtIndex:1];
    }

}


#pragma mark Moving Table Cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((Task*)[self.taskController objectAtIndexPath:indexPath]).level == 1)
    {  return NO; }
    else
    {  return YES; }
}


 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     
     
 }

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if((proposedDestinationIndexPath.section)||(proposedDestinationIndexPath.row))
    {
        return proposedDestinationIndexPath;
    }
    else
    {
        return sourceIndexPath;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task* task = (Task*)[self.taskController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", task.formattedWbs, task.taskName];
    cell.showsReorderControl = YES;
    int offset = task.level;
    cell.indentationWidth = 8;
    cell.indentationLevel = offset;
 
}

#pragma mark Button Actions

//create a new task with default values
- (IBAction)addTask:(id)sender
{

    //get selected object
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSIndexPath* updatedIndexPath;
    
    Task* selectedTask = (Task*)[self.taskController objectAtIndexPath:selectedIndexPath];
    NSLog(@"The task that after which we want to insert a new task is %@", selectedTask.wbs);
    
    Task* newTask = (Task*)[self.taskController createObject:@"Task"];

    newTask.taskName = @"new Task";
    newTask.startDate = [NSDate date];
    newTask.endDate = [NSDate date];
    newTask.duration = 480;
    newTask.effort = 480;
    newTask.effortComplete = 0;
    newTask.isMilestone = NO;
    
    //update all relevant WBS i.e. make "space" for new item
    [selectedTask reorderForInsertAfter];
    
    newTask.wbs = [selectedTask nextTaskWbs];
    newTask.project = selectedTask.project;
    
    if (selectedTask.level > 1) {
        
        //selected task was "normal" task, so new task will be normal as well
        newTask.level = selectedTask.level;
        newTask.ancestor = selectedTask.ancestor;
        updatedIndexPath = [NSIndexPath indexPathForRow:(selectedIndexPath.row +1) inSection:selectedIndexPath.section];
        
    } else {
        
        //selected task was master task, we'll insert a new child on level 2
        newTask.level = 2;
        newTask.ancestor = selectedTask;
        
        //the following statement is correct if we have multiple sections
        //updatedIndexPath = [NSIndexPath indexPathForRow:0 inSection:selectedIndexPath.section+1];
        
        //the following statement is correct if we have only one section
        updatedIndexPath = [NSIndexPath indexPathForRow:(selectedIndexPath.row +1) inSection:selectedIndexPath.section];
        
    }


    
    //save context
    [self.taskController saveContext];
    
    [[self tableView] reloadData];

    [[self tableView] selectRowAtIndexPath:updatedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


- (IBAction)changeHierarchy:(id)sender {
    
    NSLog(@"User requested change of hierarchy.");
    
    //get selected object
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    Task* selectedTask = (Task*)[self.taskController objectAtIndexPath:selectedIndexPath];
    UISegmentedControl* indentButtons = self.hierarchyController; //(UISegmentedControl*) [self.hierarchyController customView];
    
    if (self.hierarchyController.selectedSegmentIndex) {
        
        //indent
        NSLog(@"User chose to unindent item %@", selectedTask.formattedWbs);
        [selectedTask indent];
        
    } else {
        
        //un-indent
        NSLog(@"User chose to indent item %@", selectedTask.formattedWbs);
        [selectedTask unindent];
        
    }
    
    [self.taskController saveContext];
    [[self tableView] reloadData];
    [[self tableView] selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    indentButtons.selectedSegmentIndex = -1;
    
}

- (IBAction)deleteTask:(id)sender {
    
    _showDeletedButton = [NSIndexPath indexPathForRow:[self.tableView indexPathForSelectedRow].row inSection:[self.tableView indexPathForSelectedRow].section];
    [[self tableView] reloadData];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");

        UIViewController* detailController = [self.splitViewController.viewControllers lastObject] ;
        NSLog(@"The detail controller that's the last object in the split controller is %@", [detailController class]);

        [detailController performSegueWithIdentifier:@"BackFromTasksToProjectDetails" sender:detailController];

    }
}


@end
