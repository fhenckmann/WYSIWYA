//
//  ProjectTasksViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Project;
@class Task;
@class ProjectTasksDetailViewController;

@interface ProjectTasksViewController : UITableViewController <UISplitViewControllerDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) Project* project;
@property (strong, nonatomic) Task* selectedTask;
@property (strong, nonatomic) ProjectTasksDetailViewController* detailViewController;
//@property (strong, nonatomic) UISplitViewController* splitViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *hierarchyController;

- (IBAction)addTask:(id)sender;
- (IBAction)changeHierarchy:(id)sender;
- (IBAction)deleteTask:(id)sender;


@end
