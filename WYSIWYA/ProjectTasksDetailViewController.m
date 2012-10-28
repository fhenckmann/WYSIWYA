//
//  ProjectTasksDetailViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectTasksDetailViewController.h"
#import "ProjectDetailsViewController.h"
#import "Task.h"

@interface ProjectTasksDetailViewController ()

@end

@implementation ProjectTasksDetailViewController
@synthesize taskNameLabel;
@synthesize taskDescriptionLabel;
@synthesize taskStartDateLabel;
@synthesize taskFinishDateLabel;
@synthesize workEffortLabel;
@synthesize pctWorkCompleteLabel;
@synthesize milestoneCell;
@synthesize assignedResourcesLabel;
@synthesize predecessorsLabel;
@synthesize successorsLabel;

@synthesize detailItem = _detailItem;


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTaskNameLabel:nil];
    [self setTaskDescriptionLabel:nil];
    [self setTaskStartDateLabel:nil];
    [self setTaskFinishDateLabel:nil];
    [self setWorkEffortLabel:nil];
    [self setPctWorkCompleteLabel:nil];
    [self setMilestoneCell:nil];
    [self setAssignedResourcesLabel:nil];
    [self setPredecessorsLabel:nil];
    [self setSuccessorsLabel:nil];
    [self setTaskNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)setDetailItem:(Task*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    /*
     if (self.masterPopoverController != nil) {
     [self.masterPopoverController dismissPopoverAnimated:YES];
     }
     */
}

- (void)configureView
{
    // Update the user interface for the detail item.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    if (self.detailItem) {
        self.taskNameLabel.text = [NSString stringWithFormat:@"%@ - %@",self.detailItem.formattedWbs,self.detailItem.taskName];
        self.taskDescriptionLabel.text = self.detailItem.taskDescription;
        self.taskStartDateLabel.text = [dateFormatter stringFromDate:self.detailItem.startDate];
        self.taskFinishDateLabel.text = [dateFormatter stringFromDate:self.detailItem.endDate];
        self.workEffortLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.effort];
        self.pctWorkCompleteLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.pctComplete];

        if (self.detailItem.isMilestone) {
            self.milestoneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.milestoneCell.accessoryType = UITableViewCellAccessoryNone;
        }

        self.navigationItem.title = self.taskNameLabel.text;
        
    }
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

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"BackFromTasksToProjectDetails"]) {
        
        
    }
    
}

@end
