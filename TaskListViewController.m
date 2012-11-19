//
//  TaskListViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 1/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "TaskListViewController.h"
#import "Task.h"
#import "Project.h"
#import "SharedData.h"
#import "CoreDataController.h"
#import "TaskListTableViewDesign.h"
#import "TaskDetailViewController.h"
#import "IndentedUILabel.h"
#import "TaskCellView.h"


@interface TaskListViewController ()
{
    
    int _tableWidth;
    int _initialX;
    int _initialY;
    
}

@property (strong, nonatomic) UIPopoverController* popover;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TaskListViewController

@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _tableWidth = 780;
    NSLog(@"Width of table view: %d", _tableWidth);
    
    //set table view
    CGRect frame = [self.taskTableView frame];
    frame.size.width = _tableWidth;
    frame.origin.x = 0;
    [self.taskTableView setFrame:frame];
    NSLog(@"Initialising TaskListView:");
    NSLog(@"Table view: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    //set divider
    frame = [self.dragBarView frame];
    frame.origin.x = _tableWidth - (frame.size.width / 2);
    [self.dragBarView setFrame:frame];
    NSLog(@"Drag bar view: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    //set graph view
    frame = [self.graphView frame];
    frame.size.width = 1024 - 4 - _tableWidth;
    frame.origin.x = 1024 - frame.size.width;
    [self.graphView setFrame:frame];
        NSLog(@"Graph view: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    //update the table header
    
    frame = [self.midHeaderImage frame];
    frame.size.width = _tableWidth - 60;
    [self.midHeaderImage setFrame:frame];
    frame = [self.rightHeaderImage frame];
    frame.origin.x = _tableWidth - 30;
    [self.rightHeaderImage setFrame:frame];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
        //checks if a row is selected...
    if ([self.taskTableView indexPathForSelectedRow]) {
        
        NSLog(@"viewWillAppear identified that row %d is selected", [self.taskTableView indexPathForSelectedRow].row);
        
            //if yes, then set the selectedTask property to that row
        self.selectedTask = (Task*)[[SharedData sharedInstance].taskController objectInListAtIndex:[[self.taskTableView indexPathForSelectedRow] row]];
        
    } else {
        
        NSLog(@"viewWillAppear identified that no row is currently selected.");
        
            //no item selected, select top item
        [self.taskTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            //call didSelectRowAtIndexPath, as it's not called when selection is made prgrammatically
        [self tableView:self.taskTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            //and set self.selectedTask
        self.selectedTask = (Task*)[[SharedData sharedInstance].taskController objectInListAtIndex:[[self.taskTableView indexPathForSelectedRow] row]];
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[SharedData sharedInstance].taskController numberOfSections];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[SharedData sharedInstance].taskController numberOfObjectsInSection:section];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskCellView* cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;

}


 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if ([((Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:indexPath]).wbs isEqualToString:@"1"])
        {  return NO; }
     else
        {  return YES; }
 
 }



 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         Task* deleteTask = (Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:indexPath];
         
         //before we delete the task, we determine the object to highlight after the delete
         Task* highlightTask = (Task*)[[SharedData sharedInstance].taskController objectFollowing:deleteTask];
         
         if ([highlightTask.wbs isEqualToString:deleteTask.wbs]) {
             
             //there was no object following the delete object, so the path of the delete object was returned instead
             //which means that the delete object is the last in the table and we should thus highlight the preceding task
             highlightTask = (Task*)[[SharedData sharedInstance].taskController objectPreceding:deleteTask];
             
         }
         
         //update other tasks' WBS entries
         [deleteTask reorderForDelete];
         
         if ([[SharedData sharedInstance].taskController deleteObject:deleteTask]) {
             
             //handle error
             abort();
         }
         
         [self.taskTableView reloadData];
         
         NSIndexPath* newIndexPath = [[SharedData sharedInstance].taskController indexPathOfObject:highlightTask];
         [self.taskTableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
         [self tableView:self.taskTableView didSelectRowAtIndexPath:newIndexPath];
         
     }
     
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */



 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {

     if (((Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:indexPath]).level == 1)
        {  return NO; }
     else
        {  return YES; }
     
     
 }
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Task* selectedTask = (Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:indexPath];
    self.selectedTask = selectedTask;
    [SharedData sharedInstance].activeTask = selectedTask;
    
    NSLog(@"Aha! User has selected row %d", indexPath.row);
    
    [self.taskTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    /*
    
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
     
     */
    
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

- (void)configureCell:(TaskCellView*)cell atIndexPath:(NSIndexPath*)indexPath
{
    
    Task* task = (Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:indexPath];
    
    int rowNumber = indexPath.row;
    int maxRows = [[SharedData sharedInstance].taskController numberOfObjectsInSection:indexPath.section] - 1;
    
    if (rowNumber == [self.taskTableView indexPathForSelectedRow].row) {
        cell.selected = true;
    } else {
        cell.selected = false;
    }
    
    NSLog(@"Drawing row %d of a total of %d plus one rows. Row is selected: %@", rowNumber, maxRows, cell.isSelected?@"YES":@"NO");
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy hh:mm"];
    
    cell.wbsLabel.text          = task.formattedWbs;
    cell.statusIcon.image       = [UIImage imageNamed:@"icon_status_grey.png"];
    cell.taskNameLabel.text     = task.taskName;
    cell.taskNameLabel.indention= task.level*8;
    cell.pctCompleteLabel.text  = [NSString stringWithFormat:@"%d", task.pctComplete];
    cell.startDateLabel.text    = [dateFormatter stringFromDate:task.startDate];
    cell.endDateLabel.text      = [dateFormatter stringFromDate:task.endDate];
    cell.effortLabel.text       = [NSString stringWithFormat:@"%d", task.effortComplete];
    cell.assignedToLabel.text   = task.assignedTo;
    
    cell.wbsLabel.highlightedTextColor = [UIColor blackColor];
    cell.taskNameLabel.highlightedTextColor = [UIColor blackColor];
    cell.pctCompleteLabel.highlightedTextColor = [UIColor blackColor];
    cell.startDateLabel.highlightedTextColor = [UIColor blackColor];
    cell.endDateLabel.highlightedTextColor = [UIColor blackColor];
    cell.effortLabel.highlightedTextColor = [UIColor blackColor];
    cell.assignedToLabel.highlightedTextColor = [UIColor blackColor];
    
    //set width of mid-background cell and x-position of right border
    
    CGRect frame = [cell.midSection frame];
    frame.size.width = _tableWidth - 60;
    [cell.midSection setFrame:frame];
    frame = [cell.rightBorder frame];
    frame.origin.x = _tableWidth - 30;
    [cell.rightBorder setFrame:frame];
    
    //check if cell is last cell
    
    if (rowNumber < maxRows) {
        //row is neither first nor last
        
        //check if cell is selected
        if (cell.isSelected) {
            
            cell.leftBorder.image = [UIImage imageNamed:@"cell_left_highlight.png"];
            cell.midSection.image = [UIImage imageNamed:@"cell_mid_highlight.png"];
            cell.rightBorder.image = [UIImage imageNamed:@"cell_right_highlight.png"];
            
        } else {
            
            if (rowNumber % 2) {

                cell.leftBorder.image = [UIImage imageNamed:@"cell_left_white.png"];
                cell.midSection.image = [UIImage imageNamed:@"cell_mid_white.png"];
                cell.rightBorder.image = [UIImage imageNamed:@"cell_right_white.png"];
                
            } else {
                
                cell.leftBorder.image = [UIImage imageNamed:@"cell_left_grey.png"];
                cell.midSection.image = [UIImage imageNamed:@"cell_mid_grey.png"];
                cell.rightBorder.image = [UIImage imageNamed:@"cell_right_grey.png"];
                
            }
            
        }
        
    } else {
        
        //row is last
        
        //check if cell is selected
        if (cell.isSelected) {
            
            cell.leftBorder.image = [UIImage imageNamed:@"cell_bottomleft_highlight.png"];
            cell.midSection.image = [UIImage imageNamed:@"cell_bottommid_highlight.png"];
            cell.rightBorder.image = [UIImage imageNamed:@"cell_bottomright_highlight.png"];
            
        } else {
            
            if (rowNumber % 2) {
                
                cell.leftBorder.image = [UIImage imageNamed:@"cell_bottomleft_white.png"];
                cell.midSection.image = [UIImage imageNamed:@"cell_bottommid_white.png"];
                cell.rightBorder.image = [UIImage imageNamed:@"cell_bottomright_white.png"];
                
            } else {
                
                cell.leftBorder.image = [UIImage imageNamed:@"cell_bottomleft_grey.png"];
                cell.midSection.image = [UIImage imageNamed:@"cell_bottommid_grey.png"];
                cell.rightBorder.image = [UIImage imageNamed:@"cell_bottomright_grey.png"];
                
            }
            
        }
        
    }
    
    //if edit mode is on
    //cell.showsReorderControl = YES;
    
    
}

- (void)viewDidUnload
{
    [self setTaskTableView:nil];
    [self setGraphView:nil];
    [self setAddTaskButton:nil];
    [self setDeleteTaskButton:nil];
    [self setDragBarView:nil];
    [self setFullView:nil];
    [self setLeftHeaderImage:nil];
    [self setMidHeaderImage:nil];
    [self setRightHeaderImage:nil];
    [super viewDidUnload];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ShowTaskDetails"]) {
        
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        
    }

}



- (IBAction)deleteTask:(id)sender {
}


//addTask: create a task with default values then open the pop-up where user can modify values accordingly
- (IBAction) addTask:(id)sender
{
    
    //get selected object as an anchor to know where new task will be added
    NSIndexPath* selectedIndexPath = [self.taskTableView indexPathForSelectedRow];
    NSIndexPath* updatedIndexPath;
    
    Task* selectedTask = (Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:selectedIndexPath];
    NSLog(@"The task that after which we want to insert a new task is %@", selectedTask.wbs);
    
    Task* newTask = (Task*)[[SharedData sharedInstance].taskController createObject:@"Task"];
    
    newTask.taskName = @"new Task";
    newTask.taskDescription = @"";
    newTask.startDate = [NSDate date];
    newTask.endDate = [NSDate date];
    newTask.duration = 480;
    newTask.effort = 480;
    newTask.effortComplete = 0;
    newTask.isMilestone = NO;
    newTask.isFinished = NO;
    newTask.hasStarted = NO;
    newTask.dynamicScheduling = NO;
    newTask.uid = [NSString stringWithFormat:@"%@%d", selectedTask.project.uid, selectedTask.project.taskUidCounter];
    selectedTask.project.taskUidCounter++;
    
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
    
    //save context and reload table, selecting new task
    
    [[SharedData sharedInstance].taskController saveContext];
    [SharedData sharedInstance].activeTask = newTask;
    [self.taskTableView reloadData];
    [self.taskTableView selectRowAtIndexPath:updatedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    //load pop-up to allow customization of task properties
    [self performSegueWithIdentifier:@"ShowTaskDetails" sender:self];
    
    
}

- (IBAction) editMode:(id)sender {
    
    
}

- (void)popoverDidComplete
{
    
    [self.popover dismissPopoverAnimated:YES];
    
}

- (IBAction)resizeWindows:(UIPanGestureRecognizer *)sender {
    
    NSLog(@"The PanGestureRecognizer has been called!");
    CGPoint translatedPoint = [sender translationInView:self.view];
    CGPoint locationPoint = [sender locationInView:self.view];
    NSLog(@"location points are now:%f,%f", locationPoint.x, locationPoint.y);
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        _initialX = [self.dragBarView center].x;
        _initialY = [self.dragBarView center].y;
        NSLog(@"Intial coordinates of dragbar view:%d,%d", _initialX, _initialY);
        
    }
    
    //translatedPoint = CGPointMake(_initialX+translatedPoint.x, _initialY);
    _tableWidth = locationPoint.x - 30;
    if(_tableWidth<0) _tableWidth = 0;
    NSLog(@"Translated point of drag is:%f,%f", translatedPoint.x, translatedPoint.y);
    
    CGPoint newCenter = CGPointMake(_initialX + translatedPoint.x, _initialY);
	[self.dragBarView setCenter:newCenter];
    
    //set frame for tableView by changing the width depending on translated point
    CGRect frame = [self.taskTableView frame];
    frame.size.width = _tableWidth;
    [self.taskTableView setFrame:frame];
    [self.taskTableView reloadData];
    
    //set frame for graphView by calculating the new width and then setting the start point to 1024 minus this width
    frame = [self.graphView frame];
    frame.size.width = 1024 - 4 - _tableWidth;
    frame.origin.x = 1024 - frame.size.width;
    [self.graphView setFrame:frame];
    NSLog(@"Graph view now is %f pixels wide and starts at X position %f", frame.size.width, frame.origin.x);
    
    //update the table header
    
    frame = [self.midHeaderImage frame];
    frame.size.width = _tableWidth - 60;
    [self.midHeaderImage setFrame:frame];
    frame = [self.rightHeaderImage frame];
    frame.origin.x = _tableWidth - 30;
    [self.rightHeaderImage setFrame:frame];
    
	/* apparently some nice animation
     if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
		CGFloat finalX = translatedPoint.x + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);

            
        if(finalX < 0) { finalX = 0; }
        else if(finalX > 1024) { finalX = 1024;	}
            
        if(finalY < 0) { finalY = 0; }
        else if(finalY > 768) {	finalY = 1024; }
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[[sender view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
        
    }
    */
    
}
     
@end
