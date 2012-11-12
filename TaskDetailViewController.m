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
    
    // create navigation bar buttons
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
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

- (IBAction)cancel:(id)sender
{
    
    [[SharedData sharedInstance].taskController rollback];
    [self.delegate popoverDidComplete];
    
}

- (IBAction)save:(id)sender
{
    
    [[SharedData sharedInstance].taskController saveContext];
    [self.delegate popoverDidComplete];
    
}

#pragma helper classes

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
