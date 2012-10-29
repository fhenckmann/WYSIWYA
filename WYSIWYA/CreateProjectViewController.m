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
@synthesize dataController = _dataController;
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
    
    //create buttons
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done Typing" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditing:)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    [self.inputProjectName becomeFirstResponder];
    
    self.createProjectButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Project" style:UIBarButtonItemStyleBordered target:self action:@selector(createProject:)];
    

}



- (void)viewDidUnload
{
    [self setInputProjectName:nil];
    [self setInputProjectDescription:nil];
    [self setInputStartDate:nil];
    [self setInputEndDate:nil];
    [self setDatePicker:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}


#pragma mark - Table view data source


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (IBAction)cancel:(id)sender
{
    
    [self.delegate popoverDidComplete];
    
}


- (IBAction)doneEditing:(id)sender
{
    
    if ([self.inputStartDate isFirstResponder]) {
        
        [self.inputStartDate resignFirstResponder];
        
    } else if ([self.inputEndDate isFirstResponder]) {
        
        [self.inputEndDate resignFirstResponder];
        
    } else if ([self.inputProjectName isFirstResponder]) {
        
        [self.inputProjectName resignFirstResponder];
        
    } else if ([self.inputProjectDescription isFirstResponder]) {
        
        [self.inputProjectDescription resignFirstResponder];
        
    }
    
    self.navigationItem.rightBarButtonItem = self.createProjectButton;
    
}

- (IBAction)createProject:(id)sender {
    
    if ([self.inputStartDate isFirstResponder]) {
        
        [self.inputStartDate resignFirstResponder];
        
    } else if ([self.inputEndDate isFirstResponder]) {
        
        [self.inputEndDate resignFirstResponder];
        
    } else if ([self.inputProjectName isFirstResponder]) {
        
        [self.inputProjectName resignFirstResponder];
        
    } else if ([self.inputProjectDescription isFirstResponder]) {
        
        [self.inputProjectDescription resignFirstResponder];
        
    } else      
    
    if ([self.inputProjectName.text length]) {
        
        Project* newProject = (Project*)[self.dataController createObject:@"Project"];
        NSLog(@"Created new project: %@", newProject);
        newProject.projectName = self.inputProjectName.text;
        newProject.projectDescription = self.inputProjectDescription.text;
        newProject.creationDate = [NSDate date];
        newProject.lastModified = [NSDate date];
        newProject.projectStart = [NSDate date];
        newProject.projectFinish = [NSDate date];
        
        //save one main task with project
        Task* newTask = (Task*)[self.dataController createObject:@"Task"];
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
        
        Task* hiddenRootTask = (Task*)[self.dataController createObject:@"Task"];
        hiddenRootTask.wbs = @"000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000";
        newTask.ancestor = hiddenRootTask;
        hiddenRootTask.ancestor = hiddenRootTask;
        
        // Save the context.
        if ([self.dataController saveContext]) {
            
            //error
            NSLog(@"error");
            abort();
            
        } else {
            
            //project successfully saved
            
            
        }
        
        [[SharedData sharedInstance] setActiveProject:newProject];
        
        [self.delegate loadProject];

        
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    //this doesn't work - instead we have to create two buttons and assign them alternatingly to the right side of the nav bar
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.leftBarButtonItem = nil;
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.navigationItem.rightBarButtonItem = self.createProjectButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        
    [textField resignFirstResponder];

    
    return YES;
    
}

@end
