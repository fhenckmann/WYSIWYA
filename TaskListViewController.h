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



@interface TaskListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskDetailViewControllerDelegate, UIGestureRecognizerDelegate>

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
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *sliderImage;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeTaskLeftRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeTaskRightRecognizer;


- (IBAction)deleteTask:(id)sender;
- (void) addTask;
- (IBAction) editMode:(id)sender;
- (void) popoverDidComplete;

- (IBAction)resizeWindows:(UIPanGestureRecognizer *)sender;
- (IBAction)swipeDividerLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeDividerRight:(UISwipeGestureRecognizer *)sender;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (IBAction)swipeTaskLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeTaskRight:(UISwipeGestureRecognizer *)sender;





@end
