//
//  CreateProjectViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 11/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "CreateProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "CoreDataController.h"
#import "SharedData.h"


@interface CreateProjectViewController ()

@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation CreateProjectViewController


@synthesize inputProjectName = _inputProjectName;
@synthesize inputProjectDescription = _inputProjectDescription;
@synthesize inputStartDate = _inputStartDate;
@synthesize inputEndDate = _inputEndDate;
@synthesize saveButton = _saveButton;
@synthesize delegate = _delegate;
@synthesize datePicker = _datePicker;
@synthesize dateFormatter = _dateFormatter;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* today = [NSDate date];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    self.inputStartDate.text = [self.dateFormatter stringFromDate:today];
    self.inputEndDate.text = [self.dateFormatter stringFromDate:today];

    self.inputStartDate.inputView = self.datePicker;
    self.inputEndDate.inputView = self.datePicker;
    

}



- (void)viewDidUnload
{
    [self setInputProjectName:nil];
    [self setInputProjectDescription:nil];
    [self setInputStartDate:nil];
    [self setInputEndDate:nil];
    [self setDatePicker:nil];
    [self setSaveButton:nil];
    [self setInputProjectDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}


#pragma mark - Table view data source



#pragma mark - Table view delegate


- (IBAction)cancel:(id)sender
{
    
    [self.delegate popoverDidComplete];
    
}


- (IBAction)createProject:(id)sender {
    
    if ([self.inputProjectName.text length]) {
        
        Project* newProject = (Project*)[[SharedData sharedInstance].projectController createObject:@"Project"];
        NSLog(@"Created new project: %@", newProject);
        newProject.projectName = self.inputProjectName.text;
        newProject.projectDescription = self.inputProjectDescription.text;
        newProject.creationDate = [NSDate date];
        newProject.lastModified = [NSDate date];
        newProject.projectStart = [NSDate date];
        newProject.projectFinish = [NSDate date];
        newProject.uid = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
        newProject.taskUidCounter = 1;
        
        //save one main task with project
        Task* newTask = (Task*)[[SharedData sharedInstance].taskController createObject:@"Task"];
        NSLog(@"Created new task: %@", newTask);
        newTask.taskName = self.inputProjectName.text;
        newTask.taskDescription = self.inputProjectDescription.text;
        newTask.startDate = [NSDate date];
        newTask.endDate = [NSDate date];
        newTask.duration = 480;
        newTask.effort = 480;
        newTask.effortComplete = 0;
        newTask.isMilestone = NO;
        newTask.level = 1;
        newTask.wbs = @"001.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000";
        newTask.project = newProject;
        
        Task* hiddenRootTask = (Task*)[[SharedData sharedInstance].taskController createObject:@"Task"];
        hiddenRootTask.wbs = @"000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000";
        newTask.ancestor = hiddenRootTask;
        hiddenRootTask.ancestor = hiddenRootTask;
        
        // Save the context.
        if ([[SharedData sharedInstance].taskController saveContext]) {
            
            //error
            NSLog(@"error");
            abort();
            
        } else {
            
            //project successfully saved
            
            
        }
        
        [[SharedData sharedInstance] setActiveProject:newProject];
        
        [self.delegate loadProject];

        
    } else {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Provide Project Name" message:@"Please provide a project name before creating the project." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    
    
}


- (IBAction)dateChanged:(id)sender
{

    UIDatePicker *picker = (UIDatePicker*) sender;
    NSString* updatedDate = [self.dateFormatter stringFromDate:picker.date];
    
    if ([self.inputStartDate isFirstResponder]) {
        
        self.inputStartDate.text = updatedDate;
        
    } else {
        
        self.inputEndDate.text = updatedDate;
        
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        
    if ([self.inputProjectName isFirstResponder]) {
        
        [self.inputProjectName resignFirstResponder];
        [self.inputProjectDescription becomeFirstResponder];
        
    } else if ([self.inputProjectDescription isFirstResponder]) {
        
        [self.inputProjectDescription resignFirstResponder];
        [self.inputStartDate becomeFirstResponder];
        
    }
    
    
    return NO;
    
}

//don't allow the popover to be dismissed when clicking outside the window

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    
    return NO;
    
}

@end
