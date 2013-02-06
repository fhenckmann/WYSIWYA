//
//  TaskDetailViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "Task.h"
#import "SharedData.h"
#import "CoreDataController.h"

@interface TaskDetailViewController ()

{
    Task* task;
    
}

- (NSString*) effortString;

@end

@implementation TaskDetailViewController

@synthesize hasStarted = _hasStarted;
@synthesize isFinished = _isFinished;


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
    
	// load all values
    
    task = [SharedData sharedInstance].activeTask;
    
    self.wbsLabel.text = task.wbs;
    self.taskNameField.text = task.taskName;
    self.taskDetailsField.text = task.taskDescription;
    self.pctCompleteLabel.text = [NSString stringWithFormat:@"%d", task.pctComplete];
    self.pctCompleteSlider.value = task.pctComplete/100;
    self.hasStarted = task.hasStarted;
    self.isFinished = task.isFinished;
    
    if (task.isMilestone) {
        
        self.workLabel.text = @"MILESTONE";
        
    } else {
        
        self.workLabel.text = [self effortString];
    
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm"];
    self.fromDateLabel.text = [dateFormat stringFromDate:task.startDate];
    self.toDateLabel.text = [dateFormat stringFromDate:task.endDate];
    
    self.scheduleTypeLabel.text = task.dynamicScheduling?@"DYNAMIC":@"STATIC";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    
    [self setWbsLabel:nil];
    [self setTaskNameField:nil];
    [self setTaskDetailsField:nil];
    [self setPctCompleteLabel:nil];
    [self setPctCompleteSlider:nil];
    [self setHasStartedButton:nil];
    [self setIsCompleteButton:nil];
    [self setWorkLabel:nil];
    [self setFromDateLabel:nil];
    [self setToDateLabel:nil];
    [self setScheduleTypeLabel:nil];

    [super viewDidUnload];
}

- (void) setHasStarted:(BOOL)hasStarted
{
    _hasStarted = hasStarted;
    
    if (hasStarted) {
        
        [self.hasStartedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
    
    } else {
        
        [self.hasStartedButton setBackgroundImage:[UIImage imageNamed:@"checkbox_unticked.png"] forState:UIControlStateNormal];
    
    }
    
}

- (void) setIsFinished:(BOOL)isFinished
{
    _isFinished = isFinished;
    
    if (isFinished) {
        
        [self.isCompleteButton setBackgroundImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        
    } else {
        
        [self.isCompleteButton setBackgroundImage:[UIImage imageNamed:@"checkbox_unticked.png"] forState:UIControlStateNormal];
        
    }
    
}


- (IBAction) updatePctComplete:(id)sender
{
    
    [[SharedData sharedInstance].taskController saveContext];
    [self.delegate popoverDidComplete];
    
}


- (IBAction) clickHasStarted:(id)sender
{


}



- (IBAction) clickIsComplete:(id)sender
{


}



- (IBAction) showSchedule:(id)sender
{


}



- (IBAction) showResources:(id)sender
{


}



- (IBAction) showPredecessors:(id)sender
{


}

#pragma mark window / navigation



- (IBAction)closeWindow:(id)sender {
    
    if (![task.taskName isEqualToString:self.taskNameField.text]) task.taskName = self.taskNameField.text;
    if (![task.taskDescription isEqualToString:self.taskDetailsField.text]) task.taskDescription = self.taskDetailsField.text;
    if (task.pctComplete/100 != self.pctCompleteSlider.value) task.pctComplete = self.pctCompleteSlider.value * 100;
    if (task.hasStarted != self.hasStarted) task.hasStarted = self.hasStarted;
    if (task.isFinished != self.isFinished) task.isFinished = self.isFinished;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm"];
    NSDate* tempStartDate = [dateFormat dateFromString:self.fromDateLabel.text];
    NSDate* tempEndDate = [dateFormat dateFromString:self.toDateLabel.text];
    
    if(![task.startDate isEqualToDate:tempStartDate]) task.startDate = tempStartDate;
    if (![task.endDate isEqualToDate:tempEndDate]) task.endDate = tempEndDate;
    
    if ([[SharedData sharedInstance].taskController hasChanges]) {
        
        NSLog(@"DONE button pressed, we've got changes to record.");
        
        if (self.isNewTask) {
            
            NSLog(@"The task is new, we'll just save and close.");
            
            //new task - we don't ask, we just save
            [[SharedData sharedInstance].taskController saveContext];
            [self.delegate popoverDidComplete];
            
            
        } else {
            
            //task already exists, we ask if user wants to save
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Save Changes?" message:@"You have made changes to the task details. Would you like to save these changes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            
            [alertView show];
        }
        
    } else {
        
        NSLog(@"DONE button pressed, but no changes made.");
        
        [self.delegate popoverDidComplete];
        
    }
    
}

//alertView cancel and save actions

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
     
        NSLog(@"Save Changes called.");
        [[SharedData sharedInstance].taskController saveContext];
        [self.delegate popoverDidComplete];
        
    } else {

        NSLog(@"Cancel Changes called.");
        [[SharedData sharedInstance].taskController rollback];
        [self.delegate popoverDidComplete];
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}


#pragma mark helper classes

- (NSString*) effortString
{
    
    NSString* unit = @"minutes";
    float effortComplete = task.effortComplete;
    float totalEffort = task.effort;
    
    if (totalEffort >= 1440) {
        
        effortComplete = effortComplete / 1440;
        totalEffort = totalEffort / 1440;
        unit = @"days";
        
    } else if (totalEffort >= 60) {
        
        effortComplete = effortComplete / 60;
        totalEffort = totalEffort / 60;
        unit = @"hours";
        
    }
    
    return [NSString stringWithFormat:@"%.01f of %.01f %@", effortComplete, totalEffort, unit];
    
}

@end
