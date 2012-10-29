//
//  ProjectStartScreenViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 5/09/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectStartScreenViewController.h"
#import "CreateProjectViewController.h"
#import "ProjectListViewController.h"
#import "ImportProjectViewController.h"
#import "ProjectSettingsViewController.h"
#import "CoreDataController.h"
#import "Project.h"
#import "Task.h"
#import "AppDelegate.h"
#import "SharedData.h"

@interface ProjectStartScreenViewController ()


@property (strong, nonatomic) CoreDataController* projectController;
@property (strong, nonatomic) UIPopoverController* popover;

@end

@implementation ProjectStartScreenViewController

@synthesize projectController = _projectController;
@synthesize popover = _popover;
@synthesize activeProject = _activeProject;


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
	// Do any additional setup after loading the view.
    
    //create the Core Data Controller
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified" ascending:NO];
    NSArray* sortDescriptors = @[sortDescriptor];
    NSManagedObjectContext* context = [[SharedData sharedInstance] managedObjectContext];
    
    self.projectController = [[CoreDataController alloc] initWithEntity:@"Project" context:context sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:nil fetchSize:20 cacheName:nil];
    
    [[SharedData sharedInstance] setProjectController:self.projectController];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"ShowCreateProject"]) {
     
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        CreateProjectViewController* createProjectController = (CreateProjectViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        createProjectController.dataController = self.projectController;
        createProjectController.delegate = self;
     
     }
    
    if ([[segue identifier] isEqualToString:@"ShowProjectList"]) {
        
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        ProjectListViewController* projectListController = (ProjectListViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        projectListController.delegate = self;
        
    }
    
    if ([[segue identifier] isEqualToString:@"ShowImportProject"]) {
        
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        ImportProjectViewController* importProjectController = (ImportProjectViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        importProjectController.dataController = self.projectController;
        importProjectController.delegate = self;
        
        
    }
    
    if ([[segue identifier] isEqualToString:@"ShowTabBar"]) {
        
        ProjectSettingsViewController* projectSettingsController = (ProjectSettingsViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        projectSettingsController.dataController = self.projectController;
        projectSettingsController.activeProject = self.activeProject;

        
        
    }
}


- (void)popoverDidComplete
{
    
    [self.popover dismissPopoverAnimated:YES];
    
}

- (void)loadProject
{
    
    [self.popover dismissPopoverAnimated:YES];
    self.activeProject = [[SharedData sharedInstance] activeProject];
    [self performSegueWithIdentifier:@"ShowTabBar" sender:self];
    
}

@end
