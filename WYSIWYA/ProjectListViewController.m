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


@interface ProjectListViewController ()

@property (strong, nonatomic) Project* selectedProject;
@property (strong, nonatomic) CoreDataController* projectController;
@property (strong, nonatomic) UIPopoverController* popover;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@implementation ProjectListViewController

{
    //BOOL _projectListEmpty;
    BOOL _editMode;
    CoreDataController* _localProjectController;
    CoreDataController* _serverProjectController;
    RemoteDataController* _remoteController;
    NSString* _remoteControllerAction;
    NSDate* _startTime;
    Project* _deleteProject;
    
}


@synthesize detailViewController = _detailViewController;
@synthesize selectedProject = _selectedProject;
@synthesize projectController = _projectController;
@synthesize delegate = _delegate;
@synthesize cancelButton = _cancelButton;
@synthesize cancelDeleteButton = _cancelDeleteButton;
@synthesize sourceSelector = _sourceSelector;
@synthesize selectButton = _selectButton;



- (void)viewDidLoad
{
    
    NSLog(@"ProjectListViewController viewDidLoad called.");
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    //create the Core Data Controller
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified" ascending:NO];
    NSArray* sortDescriptors = @[sortDescriptor];
    
    //creating local controller
    NSManagedObjectContext* localContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext];
    _localProjectController = [[CoreDataController alloc] initWithEntity:@"Project" context:localContext sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:nil fetchSize:20 cacheName:nil];
    
    
    //creating controller for temporary server data
    NSManagedObjectContext* serverContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate]tempObjectContext];
    _serverProjectController = [[CoreDataController alloc] initWithEntity:@"Project" context:serverContext sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:nil fetchSize:20 cacheName:nil];
    
    //setting active controller to local
    self.projectController = _localProjectController;
    
    NSLog(@"Initialised project controller: %@", self.projectController.managedObjectContext);
    
    //create buttons
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.cancelDeleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Finished Deleting" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectProject:)];
    self.navigationItem.rightBarButtonItem = self.selectButton;
    
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

/*
 - (void)insertNewObject:(id)sender
 {
 Project* newProject = (Project*)[self.projectController createObject:@"Project"];
 if (newProject) {
 newProject.creationDate = [NSDate date];
 newProject.projectName = @"new project";
 } else {
 NSLog(@"Woha! Couldn't create new project.");
 }
 
 }
 */

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView called and will return %d", self.projectController.numberOfSections);
    return self.projectController.numberOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection called for section %d", section);
    return [self.projectController numberOfObjectsInSection:section];
    
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
            _deleteProject = (Project*)[self.projectController objectAtIndexPath:indexPath];
            NSDictionary* parameters = [NSDictionary dictionaryWithObject:_deleteProject.uid forKey:@"uid"];
            [_remoteController sendRequestToPage:@"projects" withParameters:parameters];
            
        } else {
            
            //delete project from local data store
            
            if ([self.projectController deleteObject:[self.projectController objectAtIndexPath:indexPath]]) {
                
                //handle error
                abort();
            }
            
            [self.tableView reloadData];
            
            //check how many objects are left. If none, remove view
            if (self.projectController.isEmpty) {
                
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
    self.selectedProject = (Project*)[self.projectController objectAtIndexPath:indexPath];
    //self.detailViewController.project = self.selectedProject;
    
}


#pragma mark DataControllerDelegate

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"configureCell called for indexPath section %d and row %d", indexPath.section, indexPath.row);
    Project* project = (Project*)[self.projectController objectAtIndexPath:indexPath];
    
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
    
    
    /*
     if ([[segue identifier] isEqualToString:@"ShowCreateProjectView"]) {
     
     self.popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
     self.navigationItem.rightBarButtonItem.enabled = NO;
     
     CreateProjectViewController *createProjectController = (CreateProjectViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
     createProjectController.delegate = self;
     
     }
     if ([[segue identifier] isEqualToString:@"LoadTabBarSegue"]) {
     
     NSLog(@"Preparing LoadTabBarSegue...");
     
     //deleting delegate relationship from splitviewcontroller
     self.splitViewController.delegate = nil;
     
     //create tab controllers and its contents
     UITabBarController* tabBarController = (UITabBarController*) [segue destinationViewController];
     ProjectTasksViewController* taskListViewController = [[tabBarController viewControllers] objectAtIndex:0];
     ProjectResourcesViewController* resourceListViewController = [[tabBarController viewControllers] objectAtIndex:1];
     
     NSLog(@"Preparing taskListViewController parameters. TaskListViewController is %@", [taskListViewController class]);
     NSLog(@"Project to pass to taskList vc is %@", self.selectedProject);
     
     
     taskListViewController.project = self.selectedProject;
     resourceListViewController.project = self.selectedProject;
     
     NSLog(@"before calling the ShowTaskDetailView segue, self.detailViewController is %@ and the splitview detail controller is %@", [self.detailViewController class], [[self.splitViewController.viewControllers lastObject] class]);
     [self.detailViewController performSegueWithIdentifier:@"ShowTaskDetailView" sender:self.detailViewController];
     
     NSLog(@"after calling ShowTaskDetailView segue, the splitview detail controller has changed to %@", [[self.splitViewController.viewControllers lastObject] class]);
     
     
     }
     */
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
    
    [self.delegate loadProject:self.selectedProject];
    
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
        
        self.projectController = _serverProjectController;
        if ([self.projectController countOfList]) {
            
            [self.projectController deleteAll];
            
        }
        
        _remoteController = [[RemoteDataController alloc] init];
        _remoteControllerAction = @"getProjects";
        _remoteController.delegate = self;
        [_remoteController sendRequestToPage:@"projects" withParameters:nil];
        
      
    } else {
        
        //selected segment = 0 --> grab list locally
        
        NSLog(@"Segmented button pressed: first segment button pressed");
        self.projectController = _localProjectController;
        
    }
    
    [self.tableView reloadData];
    
}


#pragma mark delegate methods

/*
 - (void)createProjectViewControllerDidCancel:(CreateProjectViewController *)controller {
 
 [self.popoverController dismissPopoverAnimated:YES];
 self.navigationItem.rightBarButtonItem.enabled = YES;
 
 }
 
 
 - (void)createProjectViewControllerDidFinish:(CreateProjectViewController *)controller projectName:(NSString *)projectName projectDescription:(NSString *)description {
 
 if ([projectName length]) {
 
 Project* newProject = (Project*)[self.projectController createObject:@"Project"];
 NSLog(@"Created new project: %@", newProject);
 newProject.projectName = projectName;
 newProject.projectDescription = description;
 newProject.creationDate = [NSDate date];
 newProject.lastModified = [NSDate date];
 newProject.projectStart = [NSDate date];
 newProject.projectFinish = [NSDate date];
 
 //save one main task with project
 Task* newTask = (Task*)[self.projectController createObject:@"Task"];
 NSLog(@"Created new task: %@", newTask);
 newTask.taskName = projectName;
 newTask.taskDescription = description;
 newTask.startDate = [NSDate date];
 newTask.endDate = [NSDate date];
 newTask.duration = 480;
 newTask.effort = 480;
 newTask.effortComplete = 0;
 newTask.isMilestone = NO;
 newTask.level = 1;
 newTask.wbs = @"001.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000";
 newTask.project = newProject;
 
 Task* hiddenRootTask = (Task*)[self.projectController createObject:@"Task"];
 hiddenRootTask.wbs = @"000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000";
 newTask.ancestor = hiddenRootTask;
 hiddenRootTask.ancestor = hiddenRootTask;
 
 // Save the context.
 if ([self.projectController saveContext]) {
 
 //error
 NSLog(@"error");
 abort();
 
 } else {
 
 //project successfully saved
 [[self tableView] reloadData];
 [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
 [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
 [self.detailViewController.backgroundView setHidden:YES];
 self.detailViewController.project = newProject;
 
 }
 
 }
 
 [self.popoverController dismissPopoverAnimated:YES];
 self.navigationItem.rightBarButtonItem.enabled = YES;
 
 }
 */


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
            
            Project* newProject = (Project*)[self.projectController createObject:@"Project"];
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
        [self.projectController saveContext];
        
    } else if ([_remoteControllerAction isEqualToString:@"deleteProject"]) {
        
        id firstResult = [results objectAtIndex:0];
        NSLog(@"The class of the returned parameter after the delete is %@", [firstResult class]);
        
        // object _deleteProject holds the project managed data object that was deleted on the server. Now needs to be deleted from the temporary store (if we're still looking at it)
        
        if ((_deleteProject) && (self.sourceSelector.selectedSegmentIndex)) {
            
            if ([self.projectController deleteObject:_deleteProject]) {
                
                //handle error
                abort();
            }
            
            _deleteProject = nil;
            [self.tableView reloadData];
            
            //check how many objects are left. If none, remove view
            if (self.projectController.isEmpty) {
                
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
