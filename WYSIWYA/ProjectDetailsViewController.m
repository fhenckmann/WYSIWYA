//
//  ProjectDetailsViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 12/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "ProjectTasksViewController.h"
#import "ProjectTasksDetailViewController.h"
#import "Project.h"

@interface ProjectDetailsViewController () 

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation ProjectDetailsViewController 

@synthesize backgroundView = _backgroundView;
@synthesize projectNameLabel = _projectNameLabel;
@synthesize projectDescriptionLabel = _projectDescriptionLabel;
@synthesize creationDateLabel = _creationDateLabel;
@synthesize lastModifiedLabel = _lastModifiedLabel;
@synthesize lastTaskUpdateLabel = _lastTaskUpdateLabel;
@synthesize numberOfTasksLabel = _numberOfTasksLabel;
@synthesize projectStartLabel = _projectStartLabel;
@synthesize projectEndLabel = _projectEndLabel;
@synthesize navBar = _navBar;
@synthesize project = _project;
@synthesize masterViewController = _masterViewController;



- (void)viewDidLoad
{
    [super viewDidLoad];

    //set detail View Controller details
    //why this: self.masterViewController = (WYSIWIAMasterViewController *)[[self.splitViewController.navigationController viewControllers] objectAtIndex:0];
    
}

- (void)viewDidUnload
{
    [self setProjectNameLabel:nil];
    [self setProjectDescriptionLabel:nil];
    [self setCreationDateLabel:nil];
    [self setLastModifiedLabel:nil];
    [self setLastTaskUpdateLabel:nil];
    [self setNumberOfTasksLabel:nil];
    [self setProjectStartLabel:nil];
    [self setProjectEndLabel:nil];

    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Managing the popover



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)setProject:(Project*)newProject
{
  
        _project = newProject;
        [self configureView];

}

- (void)configureView
{
    // Update the user interface for the detail item.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    if (self.project) {
        self.projectNameLabel.text = self.project.projectName;
        self.projectDescriptionLabel.text = self.project.projectDescription;
        self.creationDateLabel.text =  [dateFormatter stringFromDate:self.project.creationDate];
        self.lastModifiedLabel.text =  [dateFormatter stringFromDate:self.project.lastModified];
        int numberOfTasks = [self.project.tasks count]-1;
        self.numberOfTasksLabel.text = [NSString stringWithFormat:@"%d", numberOfTasks];
        self.projectStartLabel.text =  [dateFormatter stringFromDate:self.project.projectStart];
        self.projectEndLabel.text =  [dateFormatter stringFromDate:self.project.projectFinish];
        self.navBar.topItem.title = [NSString stringWithFormat:@"Project '%@'", self.projectNameLabel.text];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ShowTaskDetailView"]) {
        
        ProjectTasksDetailViewController* taskDetailController = (ProjectTasksDetailViewController*) [segue destinationViewController];
        NSLog(@"ShowTaskDetailView segue called. TaskDetailController is %@", [taskDetailController class]);
        
        
    }

}


- (IBAction)openProject: (id) sender
{
    [[self delegate] loadTabBarSegue];
    
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

#pragma mark UISplitViewControllerDelegate classes

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Project List", @"Project List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    [self.masterPopoverController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
