//
//  TaskListViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 1/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@class TaskListTableViewDesign;

@interface TaskListViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) Task* selectedTask;
@property (weak, nonatomic) IBOutlet TaskListTableViewDesign *taskTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *columnSizeSlider;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBox;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

- (IBAction)addTask:(id)sender;
- (IBAction)editMode:(id)sender;


@end
