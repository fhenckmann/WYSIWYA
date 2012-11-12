//
//  ProjectListViewController.m
//  Working Title
//
//  Created by Fabian Henckmann on 10/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectDetailsViewController.h"
#import "CreateProjectViewController.h"
#import "CoreDataController.h"
#import "ProjectTasksViewController.h"
#import "ProjectResourcesViewController.h"
#import "Project.h"
#import "Task.h"
#import "AppDelegate.h"
#import "LoadProgressViewController.h"
#import "SharedData.h"


@interface ProjectListViewController ()

@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) CoreDataController* chosenController;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@implementation ProjectListViewController

{
    BOOL _editMode;
    RemoteDataController* _remoteController;
    NSString* _remoteControllerAction;
    NSDate* _startTime;
    Project* _deleteProject;
    
}


@synthesize delegate = _delegate;
@synthesize cancelButton = _cancelButton;
@synthesize cancelDeleteButton = _cancelDeleteButton;
@synthesize sourceSelector = _sourceSelector;
@synthesize selectButton = _selectButton;
@synthesize chosenController = _chosenController;



- (void)viewDidLoad
{
    
    NSLog(@"ProjectListViewController viewDidLoad called.");
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    //create buttons
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.cancelDeleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Finished Deleting" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectProject:)];
    self.navigationItem.rightBarButtonItem = self.selectButton;
    
    //set the source for the project list, start with local controller    
    self.chosenController = [SharedData sharedInstance].projectController;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ProjectListViewController viewWillAppear called.");
    [super viewDidAppear:animated];
    
    _editMode = NO;
    [self.selectButton setEnabled:NO];
    
    /*
     
     //set detail View Controller details
     self.detailViewController = (ProjectDetailsViewController *)[self.splitViewController.viewControllers lastObject];
     
     //creating logo background view and setting sizing appropriately
     
     self.detailViewController.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wysiwya_logo.png"]];
     self.detailViewController.backgroundView.contentMode = UIViewContentModeCenter;
     self.detailViewController.backgroundView.frame = CGRectMake(0,0,self.detailViewController.tableView.bounds.size.width,self.detailViewController.tableView.bounds.size.height);
     
     self.detailViewController.tableView.autoresizesSubviews = YES;
     self.detailViewController.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     
     [self.detailViewController.backgroundView setBackgroundColor:[UIColor whiteColor]];
     [self.detailViewController.backgroundView setHidden:YES];
     [self.detailViewController.tableView addSubview:self.detailViewController.backgroundView];
     
     //check if we have any projects and initialise view accordingly
     
     
     self.detailViewController.delegate = self;
     
     //check if a previous selection exists from last call
     if ([self.tableView indexPathForSelectedRow]) {
     
     NSLog(@"A cell has already been selected: %d", [[self.tableView indexPathForSelectedRow] row]);
     self.selectedProject = (Project*)[self.projectController objectInListAtIndex:[[self.tableView indexPathForSelectedRow] row]];
     self.detailViewController.project = self.selectedProject;
     
     } else {
     
     if (self.projectController.isEmpty) {
     
     NSLog(@"Project Controller is empty.");
     [self.navigationItem.leftBarButtonItem setEnabled:NO];
     [self.detailViewController.backgroundView setHidden:NO];
     self.detailViewController.navigationItem.title = @"";
     
     
     } else {
     
     NSLog(@"Start of Master view found table to NOT be empty. Will retrieve first element.");
     self.selectedProject = (Project*)[self.projectController objectInListAtIndex:0];
     self.detailViewController.project = self.selectedProject;
     NSLog(@"And that element is %@", self.selectedProject);
     [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
     
     
     }
     }
     
     */
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setSelectButton:nil];
    [self setCancelDeleteButton:nil];
    [self setSourceSelector:nil];
    [self setChosenController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView called and will return %d", self.chosenController.numberOfSections);
    return self.chosenController.numberOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection called for section %d", section);
    return [self.chosenController numberOfObjectsInSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Called cellForRowAtIndexPath with section %d and row %d", indexPath.section, indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTitleCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.sourceSelector.selectedSegmentIndex) {
            
            //delete project from server
            _remoteController = [[RemoteDataController alloc] init];
            _remoteControllerAction = @"deleteProject";
            _remoteController.delegate = self;
            _deleteProject = (Project*)[self.chosenController objectAtIndexPath:indexPath];
            NSDictionary* parameters = [NSDictionary dictionaryWithObject:_deleteProject.uid forKey:@"uid"];
            [_remoteController sendRequestToPage:@"projects" withParameters:parameters];
            
        } else {
            
            //delete project from local data store
            
            if ([self.chosenController deleteObject:[self.chosenController objectAtIndexPath:indexPath]]) {
                
                //handle error
                abort();
            }
            
            [self.tableView reloadData];
            
            //check how many objects are left. If none, remove view
            if (self.chosenController.isEmpty) {
                
                [self.delegate popoverDidComplete];
                
            }
            
        }
                

    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // The table view should not be re-orderable.
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRowAtIndexPath called for section %d and row %d", indexPath.section, indexPath.row);
    [self.selectButton setEnabled:YES];
    [SharedData sharedInstance].activeProject = (Project*)[self.chosenController objectAtIndexPath:indexPath];
    
    
}


#pragma mark DataControllerDelegate

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"configureCell called for indexPath section %d and row %d", indexPath.section, indexPath.row);
    Project* project = (Project*)[self.chosenController objectAtIndexPath:indexPath];
    
    //set main text of table cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",project.projectName,project.projectDescription];
    
    //set subtitle of table cell
    int numberOfTasks = project.numberOfTasks;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString* lastModifiedText = [dateFormatter stringFromDate:project.lastModified];
    NSString* createdText = [dateFormatter stringFromDate:project.creationDate];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d tasks, created on %@, last modified on %@", numberOfTasks, createdText, lastModifiedText];
    
}


- (void) insertSections:(NSUInteger)sectionIndex
{
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}


- (void) deleteSections:(NSUInteger)sectionIndex
{
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}


- (void) insertRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void) deleteRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void) configureCellAtIndexPath:(NSIndexPath*)indexPath
{
    
    NSLog(@"Data controller called view's configureCellAtIndexPath method for section %d and row %d", indexPath.section, indexPath.row);
    [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];

}


- (void) beginUpdates
{
    
    [self.tableView beginUpdates];

}


- (void) endUpdates
{
    
    [self.tableView endUpdates];
    
}


#pragma mark Other methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLoadProgress"]) {
        
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        
    }
    
}


- (IBAction)cancel:(id)sender {
    
    if (_editMode) {
        
        //table is currently in Edit mode and the Cancel button is used to exit the Edit mode
        
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = self.cancelButton;
        self.navigationItem.rightBarButtonItem = self.selectButton;
        [self.selectButton setEnabled:NO];
        _editMode = NO;
        
    } else {
        
        //table is not in Edit mode, Cancel button was pressed to leave popover
        [self.delegate popoverDidComplete];
        
    }
    
    
}


- (IBAction)selectProject:(id)sender
{
    
    [self.delegate loadProject];
    
}


- (IBAction)invokeEditMode:(id)sender {
    
    [self.tableView setEditing:YES animated:YES];
    _editMode = YES;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = self.cancelDeleteButton;
    
}

- (IBAction)selectListSource:(id)sender forEvent:(UIEvent *)event {
    
    if (self.sourceSelector.selectedSegmentIndex) {
        
        //selected segment = 1 --> grab project list from server
        
        _startTime = [NSDate date];
        [self performSegueWithIdentifier:@"ShowLoadProgress" sender:self];
        
        self.chosenController = [[SharedData sharedInstance] freshRemoteController];
        if ([self.chosenController countOfList]) {
            
            [self.chosenController deleteAll];
            
        }
        
        _remoteController = [[RemoteDataController alloc] init];
        _remoteControllerAction = @"getProjects";
        _remoteController.delegate = self;
        [_remoteController sendRequestToPage:@"projects" withParameters:nil];
        
      
    } else {
        
        //selected segment = 0 --> grab list locally
        
        NSLog(@"Segmented button pressed: first segment button pressed");
        self.chosenController = [[SharedData sharedInstance] freshProjectController];
        
    }
    
    [self.tableView reloadData];
    
}


- (void) updateProgress:(NSNumber*)progress
{
    
    LoadProgressViewController* progressController = (LoadProgressViewController*)self.popover.contentViewController;
    float currentProgress = [progressController.progressBar progress];
    [progressController.progressBar setProgress:(currentProgress + ((1.0-currentProgress)/2.0)) animated:YES];
    
}


- (void) processResults:(NSArray*)results
{
    
    if ([_remoteControllerAction isEqualToString:@"getProjects"]) {
        
        //processing getProjects request
        
        LoadProgressViewController* progressController = (LoadProgressViewController*)self.popover.contentViewController;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDateFormatter* dateTimeFormatter = [[NSDateFormatter alloc]init];
        [dateTimeFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
        
        NSLog(@"Number of results from server: %d", [results count]);
        
        for (NSDictionary* dataObject in results) {
            
            Project* newProject = (Project*)[[[SharedData sharedInstance] remoteProjectController] createObject:@"Project"];
            newProject.projectName = [dataObject valueForKey:@"projectName"];
            newProject.projectDescription = [dataObject valueForKey:@"projectDescription"];
            newProject.creationDate = [dateTimeFormatter dateFromString:[dataObject valueForKey:@"creationDate"]];
            newProject.lastModified = [dateTimeFormatter dateFromString:[dataObject valueForKey:@"lastModified"]];
            newProject.projectStart = [dateFormatter dateFromString:[dataObject valueForKey:@"projectStart"]];
            newProject.projectFinish = [dateFormatter dateFromString:[dataObject valueForKey:@"projectFinish"]];
            newProject.uid = [dataObject valueForKey:@"uid"];
            newProject.numberOfTasks = [[dataObject valueForKey:@"tasks"] intValue];
            NSLog(@"Created new project as part of JSON deserialization: %@", newProject);
            
        }
        
        [progressController.progressBar setProgress:1.0 animated:YES];
        [self.popover dismissPopoverAnimated:YES];
        [[SharedData sharedInstance] saveContext];
        
    } else if ([_remoteControllerAction isEqualToString:@"deleteProject"]) {
        
        id firstResult = [results objectAtIndex:0];
        NSLog(@"The class of the returned parameter after the delete is %@", [firstResult class]);
        
        // object _deleteProject holds the project managed data object that was deleted on the server. Now needs to be deleted from the temporary store (if we're still looking at it)
        
        if ((_deleteProject) && (self.sourceSelector.selectedSegmentIndex)) {
            
            if ([[SharedData sharedInstance].remoteProjectController deleteObject:_deleteProject]) {
                
                //handle error
                abort();
            }
            
            _deleteProject = nil;
            [self.tableView reloadData];
            
            //check how many objects are left. If none, remove view
            if (self.chosenController.isEmpty) {
                
                [self.delegate popoverDidComplete];
                
            }
            
        }
        
    }

    //remote call was fully processed, set the remote controller action tracker to empty string
    _remoteControllerAction = @"";

    [self.tableView reloadData];
    
}


- (void) handleError:(NSString*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Setting segmented button to select first segment. Will it call my own method?");
    [self.sourceSelector setSelectedSegmentIndex:0];
    
}


@end
