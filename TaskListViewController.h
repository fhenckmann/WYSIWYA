//
//  TaskListViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 1/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"

@class Task;
@class TaskListTableViewDesign;



@interface TaskListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskDetailViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIView *dragBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *graphView;
@property (strong, nonatomic) Task* selectedTask;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteTaskButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftHeaderImage;
@property (weak, nonatomic) IBOutlet UIImageView *midHeaderImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightHeaderImage;


- (IBAction)deleteTask:(id)sender;
- (IBAction) addTask:(id)sender;
- (IBAction) editMode:(id)sender;
- (void) popoverDidComplete;
- (IBAction)resizeWindows:(UIPanGestureRecognizer *)sender;


@end
