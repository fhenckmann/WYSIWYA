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
    BOOL _buttonsOnLeftSide;
    int _dividerMiddlePosition;
    BOOL _editMode;
    
}

@property (strong, nonatomic) UIPopoverController* popover;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setButtonStatus;
- (void)updateSubviews;
- (void)moveButtons:(BOOL)right;
- (void)finalizeGestureMovement:(UIGestureRecognizer*) recognizer;
- (UIView*) getCellBackground:(NSString*) viewType;

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
//initial width of task list table
    _tableWidth = 780;
    
//initial position of the divider (used for swiping)
    _dividerMiddlePosition = 780;
    
//initial position of the info, delete and add task buttons
    _buttonsOnLeftSide = YES;
    
//set table view
    CGRect frame = [self.taskTableView frame];
    frame.size.width = _tableWidth;
    frame.origin.x = 0;
    [self.taskTableView setFrame:frame];
    NSLog(@"Initialising TaskListView:");
    NSLog(@"Table view: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
//set divider
    frame = [self.dragBarView frame];
    frame.size.width = 60;
    frame.origin.x = _tableWidth - (frame.size.width / 2);
    [self.dragBarView setFrame:frame];
    NSLog(@"Drag bar view: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    frame = [self.sliderImage frame];
    frame.origin.x=0;
    frame.origin.y=-8;
    [self.sliderImage setFrame:frame];
    NSLog(@"Slider image: x=%f, y=%f, width=%f, height=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    [self.view bringSubviewToFront:self.dragBarView];
    
//set graph view
    frame = [self.graphView frame];
    frame.size.width = 1024 - _tableWidth;
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
    
//additional formatting for the buttons
    [self.infoButton setImage:[UIImage imageNamed:@"button_info_highlight.png"] forState:UIControlStateHighlighted];
    [self.infoButton setImage:[UIImage imageNamed:@"button_info_disabled.png"] forState:UIControlStateDisabled];
    [self.addTaskButton setImage:[UIImage imageNamed:@"button_add_highlight.png"] forState:UIControlStateHighlighted];
    [self.addTaskButton setImage:[UIImage imageNamed:@"button_add_disabled.png"] forState:UIControlStateDisabled];
    [self.deleteTaskButton setImage:[UIImage imageNamed:@"button_delete_highlight.png"] forState:UIControlStateHighlighted];
    [self.deleteTaskButton setImage:[UIImage imageNamed:@"button_delete_disabled.png"] forState:UIControlStateDisabled];
    [self.editButton setImage:[UIImage imageNamed:@"button_edit_highlight.png"] forState:UIControlStateHighlighted];
    
//edit settings
    _editMode = NO;
    [[self swipeTaskLeftRecognizer] setEnabled:NO];
    [[self swipeTaskRightRecognizer] setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
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

- (UIView*)getCellBackground:(NSString *)viewType
{
    CGRect frame = CGRectMake(0,0,_tableWidth,30);
    UIView* returnView = [[UIView alloc] initWithFrame:frame];
    
    if ([viewType isEqualToString:@"middle_even"]) {
        
        //first the even cell that's not the last cell in the table
        UIImageView* leftSideEven = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_left_white.png"]];
        UIImageView* middleEven = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_mid_white.png"]];
        UIImageView* rightSideEven = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_right_white.png"]];
        [returnView addSubview:leftSideEven];
        leftSideEven.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:middleEven];
        middleEven.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:rightSideEven];
        rightSideEven.frame = CGRectMake(_tableWidth-30,0,30,30);
        
    } else if ([viewType isEqualToString:@"middle_odd"]) {
        
        //then the odd cell that's not the last cell in the table
        UIImageView* leftSideOdd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_left_grey.png"]];
        UIImageView* middleOdd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_mid_grey.png"]];
        UIImageView* rightSideOdd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_right_grey.png"]];
        [returnView addSubview:leftSideOdd];
        leftSideOdd.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:middleOdd];
        middleOdd.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:rightSideOdd];
        rightSideOdd.frame = CGRectMake(_tableWidth-30,0,30,30);
        
    } else if ([viewType isEqualToString:@"end_even"]) {
        
        //now the even cell that IS the last cell in the table
        UIImageView* leftSideEvenBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomleft_white.png"]];
        UIImageView* middleEvenBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottommid_white.png"]];
        UIImageView* rightSideEvenBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomright_white.png"]];
        [returnView addSubview:leftSideEvenBottom];
        leftSideEvenBottom.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:middleEvenBottom];
        middleEvenBottom.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:rightSideEvenBottom];
        rightSideEvenBottom.frame = CGRectMake(_tableWidth-30,0,30,30);
        
        
    } else if ([viewType isEqualToString:@"end_odd"]) {
        
        //and then the odd cell that's the last cell in the table
        UIImageView* leftSideOddBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomleft_grey.png"]];
        UIImageView* middleOddBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottommid_grey.png"]];
        UIImageView* rightSideOddBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomright_grey.png"]];
        [returnView addSubview:leftSideOddBottom];
        leftSideOddBottom.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:middleOddBottom];
        middleOddBottom.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:rightSideOddBottom];
        rightSideOddBottom.frame = CGRectMake(_tableWidth-30,0,30,30);
        
    } else if ([viewType isEqualToString:@"middle_highlight"]) {
        
        //now the highlighted cells, firs the normal cells...
        UIImageView* highlightLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_left_highlight.png"]];
        UIImageView* highlightMiddle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_mid_highlight.png"]];
        UIImageView* highlightRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_right_highlight.png"]];
        [returnView addSubview:highlightLeft];
        highlightLeft.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:highlightMiddle];
        highlightMiddle.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:highlightRight];
        highlightRight.frame = CGRectMake(_tableWidth-30,0,30,30);
        
    } else if ([viewType isEqualToString:@"end_highlight"]) {
        
        //...and then the ones at the bottom of the table
        UIImageView* highlightLeftBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomleft_highlight.png"]];
        UIImageView* highlightMiddleBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottommid_highlight.png"]];
        UIImageView* highlightRightBottom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottomright_highlight.png"]];
        [returnView addSubview:highlightLeftBottom];
        highlightLeftBottom.frame = CGRectMake(0,0,30,30);
        [returnView addSubview:highlightMiddleBottom];
        highlightMiddleBottom.frame = CGRectMake(30,0,_tableWidth-60,30);
        [returnView addSubview:highlightRightBottom];
        highlightRightBottom.frame = CGRectMake(_tableWidth-30,0,30,30);
        
    }
    
    return returnView;
    
}

- (void)setButtonStatus
{
    
    
    
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
    int lastRow = [[SharedData sharedInstance].taskController numberOfObjectsInSection:indexPath.section] - 1;
    
    cell.wbsLabel.highlightedTextColor = [UIColor whiteColor];
    cell.taskNameLabel.highlightedTextColor = [UIColor whiteColor];
    cell.pctCompleteLabel.highlightedTextColor = [UIColor whiteColor];
    cell.startDateLabel.highlightedTextColor = [UIColor whiteColor];
    cell.endDateLabel.highlightedTextColor = [UIColor whiteColor];
    cell.effortLabel.highlightedTextColor = [UIColor whiteColor];
    cell.assignedToLabel.highlightedTextColor = [UIColor whiteColor];
    
    NSLog(@"Drawing row %d of a total of %d plus one rows. Row is selected: %@", rowNumber, lastRow, cell.isSelected?@"YES":@"NO");
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy hh:mm"];
    
    cell.wbsLabel.text          = task.formattedWbs;
    cell.statusIcon.image       = [UIImage imageNamed:@"icon_status_grey.png"];
    cell.taskNameLabel.text     = task.taskName;
    cell.taskNameLabel.indention= task.level*8;
    cell.pctCompleteLabel.text  = [NSString stringWithFormat:@"%d%%", task.pctComplete];
    cell.startDateLabel.text    = [dateFormatter stringFromDate:task.startDate];
    cell.endDateLabel.text      = [dateFormatter stringFromDate:task.endDate];
    cell.effortLabel.text       = [NSString stringWithFormat:@"%d", task.effortComplete];
    cell.assignedToLabel.text   = task.assignedTo;
    
    if (rowNumber < lastRow) {
        
        cell.selectedBackgroundView = [self getCellBackground:@"middle_highlight"];
        
        if (rowNumber % 2) {
            
            cell.backgroundView = [self getCellBackground:@"middle_odd"];
            
        } else {

            cell.backgroundView = [self getCellBackground:@"middle_even"];
        }
        
    } else {
        
        cell.selectedBackgroundView = [self getCellBackground:@"end_highlight"];
        
        if (rowNumber % 2) {
            
            cell.backgroundView = [self getCellBackground:@"end_odd"];
            
        } else {

            cell.backgroundView = [self getCellBackground:@"end_even"];
            
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
    [self setInfoButton:nil];
    [self setPanGestureRecognizer:nil];
    [self setSwipeLeftRecognizer:nil];
    [self setSwipeRightRecognizer:nil];
    [self setSliderImage:nil];
    [self setEditButton:nil];
    [self setSwipeTaskLeftRecognizer:nil];
    [self setSwipeTaskRightRecognizer:nil];
    [super viewDidUnload];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ShowNewTask"]) {
        
        [self addTask];
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        TaskDetailViewController* taskDetailController = (TaskDetailViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        taskDetailController.delegate = self;
        taskDetailController.isNewTask = YES;
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"ShowExistingTask"]) {
        
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        TaskDetailViewController* taskDetailController = (TaskDetailViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        taskDetailController.delegate = self;
        taskDetailController.isNewTask = NO;
        
    }
    

}



- (IBAction)deleteTask:(id)sender {
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Delete Task" message:@"Do you really want to delete this task?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alertView show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        
        NSLog(@"Delete action called.");
        Task* deleteTask = (Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:[self.taskTableView indexPathForSelectedRow]];
        
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
        
        
    } else {
        
        NSLog(@"Cancel delete called.");
        
    }
    
}


//addTask: create a task with default values then open the pop-up where user can modify values accordingly
- (void) addTask
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
        
    } else {
        
        //selected task was master task, we'll insert a new child on level 2
        newTask.level = 2;
        newTask.ancestor = selectedTask;
        
    }
    
    //save context and reload table, selecting new task
    
    [[SharedData sharedInstance].taskController saveContext];
    [SharedData sharedInstance].activeTask = newTask;
    self.selectedTask = newTask;
    [self.taskTableView reloadData];
    updatedIndexPath = [[SharedData sharedInstance].taskController indexPathOfObject:newTask];
    [self.taskTableView selectRowAtIndexPath:updatedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

- (IBAction) editMode:(id)sender {
    
    if (_editMode) {
        
        _editMode = NO;
        [[self swipeTaskLeftRecognizer] setEnabled:NO];
        [[self swipeTaskRightRecognizer] setEnabled:NO];
        [self.editButton setImage:[UIImage imageNamed:@"button_edit.png"] forState:UIControlStateNormal];
        
    } else {
        
        _editMode = YES;
        [[self swipeTaskLeftRecognizer] setEnabled:YES];
        [[self swipeTaskRightRecognizer] setEnabled:YES];
        [self.editButton setImage:[UIImage imageNamed:@"button_edit_active.png"] forState:UIControlStateNormal];
        
    }
    
    
}

- (void)popoverDidComplete
{
    
    NSLog(@"PopoverDidComplete called in TaskListViewController");
    [self.popover dismissPopoverAnimated:YES];
    [self.taskTableView reloadData];
    NSIndexPath* taskPath = [[SharedData sharedInstance].taskController indexPathOfObject:self.selectedTask];
    [self.taskTableView selectRowAtIndexPath:taskPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    //call didSelectRowAtIndexPath, as it's not called when selection is made prgrammatically
    [self tableView:self.taskTableView didSelectRowAtIndexPath:taskPath];
    
}

#pragma mark Window Resizing Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
    
}

- (IBAction)swipeTaskLeft:(UISwipeGestureRecognizer *)sender {
    
    NSLog(@"SwipeTaskLeft called.");
    
    CGPoint swipeLocation = [sender locationInView:[self taskTableView]];
    NSIndexPath* swipedIndexPath = [[self taskTableView] indexPathForRowAtPoint:swipeLocation];
    Task* swipedTask = ((Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:swipedIndexPath]);
    
    if ([swipedTask canUnindent]) {
        
        //unindent chosen task
        [swipedTask unindent];
        
    } else {
        
        //can't unindent animation
    }
    
    
}

- (IBAction)swipeTaskRight:(UISwipeGestureRecognizer *)sender {
    
    NSLog(@"SwipeTaskRight called.");
    
    CGPoint swipeLocation = [sender locationInView:[self taskTableView]];
    NSIndexPath* swipedIndexPath = [[self taskTableView] indexPathForRowAtPoint:swipeLocation];
    Task* swipedTask = ((Task*)[[SharedData sharedInstance].taskController objectAtIndexPath:swipedIndexPath]);
    
    if ([swipedTask canIndent]) {
        
        //indent chosen task
        [swipedTask indent];
        
    } else {
        
        //can't indent animation
    }    
    
}

- (IBAction)resizeWindows:(UIPanGestureRecognizer *)sender {
    
    CGPoint translatedPoint = [sender translationInView:self.dragBarView];
    
//at the beginning of the drag action, we need to set the reference point
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        _initialX = [self.dragBarView frame].origin.x;
        NSLog(@"Intial coordinates of dragbar view:%d", _initialX);
        
    }
    
    _tableWidth = _initialX + 30 + translatedPoint.x;
    
    [self updateSubviews];    
    
//determine in which direction we're going
    BOOL goingLeft = (_initialX > [self.dragBarView frame].origin.x)? YES : NO;
    
//if we're close to the border, then call the animation that will move the bar to the border
    if ((_tableWidth < 200) && (goingLeft)) [self finalizeGestureMovement:sender];
    if ((_tableWidth > 900) && (!goingLeft)) [self finalizeGestureMovement:sender];
        
    
    if ((_tableWidth < 200)&&(_buttonsOnLeftSide)) {
        
        [self moveButtons:YES];
        
    } else if ((_tableWidth > 199) && (!_buttonsOnLeftSide)) {
        
        [self moveButtons:NO];
        
    }

     if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
         [self finalizeGestureMovement:sender];
        
    }
    
}

- (IBAction)swipeDividerLeft:(UISwipeGestureRecognizer *)sender {
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
    if ([self.dragBarView frame].origin.x >900) {
            
//move divider from the very right back to the center position
        _tableWidth = _dividerMiddlePosition;
            
    } else {
            
//move divider to the left
        _tableWidth = 0;
        [self moveButtons:YES];
            
    }
    
    [self updateSubviews];        
    [UIView commitAnimations];        
    
}


- (IBAction)swipeDividerRight:(UISwipeGestureRecognizer *)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if ([self.dragBarView frame].origin.x < 100) {
        
        //move divider from the left back to the middle
        _tableWidth = _dividerMiddlePosition;
        [self moveButtons:NO];
        
    } else {
        
        //move divider to the very right
        _tableWidth = 1020;
        
    }
    
    [self updateSubviews];    
    [UIView commitAnimations];
    
}

- (void) finalizeGestureMovement:(UIGestureRecognizer*)recognizer
{
    
    recognizer.enabled = NO;
    
    if (_tableWidth < 200) {
            
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _tableWidth = 0;
            
        [self updateSubviews];
        [UIView commitAnimations];
        
        if (_buttonsOnLeftSide) [self moveButtons:YES];
            
        
    } else if (_tableWidth > 900) {
            
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _tableWidth = 1020;
            
        [self updateSubviews];
            
        [UIView commitAnimations];
        
        if (!_buttonsOnLeftSide) [self moveButtons:NO];
                    
    }
    
    _dividerMiddlePosition = _tableWidth;
    
    recognizer.enabled = YES;
    
}



- (void) updateSubviews
{
    
    CGRect frame = [self.dragBarView frame];
    frame.origin.x = _tableWidth - 30;
	[self.dragBarView setFrame:frame];
    
//set frame for tableView by changing the width depending on translated point
    frame = [self.taskTableView frame];
    frame.size.width = _tableWidth;
    [self.taskTableView setFrame:frame];
    [self.taskTableView reloadData];
    
//set frame for graphView by calculating the new width and then setting the start point to 1024 minus this width
    frame = [self.graphView frame];
    frame.size.width = 1024 - _tableWidth;
    frame.origin.x = 1024 - frame.size.width;
    [self.graphView setFrame:frame];
    NSLog(@"Graph view now is %f pixels wide and starts at X position %f", frame.size.width, frame.origin.x);
    
//update the table header
    
    frame = [self.midHeaderImage frame];
//if the table is too small to have a mid section, then set width to 0, otherwise to total width - 60
    frame.size.width = (_tableWidth > 59)?_tableWidth - 60:0;
    [self.midHeaderImage setFrame:frame];
    frame = [self.rightHeaderImage frame];
    frame.origin.x = _tableWidth - 30;
    [self.rightHeaderImage setFrame:frame];
    
}

- (void)moveButtons:(BOOL)right
{
    
    if (right) {
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        
        CGRect buttonFrame = [self.infoButton frame];
        buttonFrame.origin.x = 930;
        [self.infoButton setFrame:buttonFrame];
        buttonFrame.origin.x = 978;
        [self.deleteTaskButton setFrame:buttonFrame];
                
        [UIView commitAnimations];
        
        //hide add button
        buttonFrame.origin.x = 1200;
        [self.addTaskButton setFrame:buttonFrame];
        
        _buttonsOnLeftSide = NO;
        
        
    } else {
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        CGRect buttonFrame = [self.infoButton frame];
        buttonFrame.origin.x = 8;
        [self.infoButton setFrame:buttonFrame];
        buttonFrame.origin.x = 56;
        [self.addTaskButton setFrame:buttonFrame];
        buttonFrame.origin.x = 104;
        [self.deleteTaskButton setFrame:buttonFrame];
        
        [UIView commitAnimations];
        
        _buttonsOnLeftSide = YES;
        
    }
    
}




@end
