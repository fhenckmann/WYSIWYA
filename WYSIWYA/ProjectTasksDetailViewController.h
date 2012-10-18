//
//  ProjectTasksDetailViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class Task;

@interface ProjectTasksDetailViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Task* detailItem;

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskFinishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *workEffortLabel;
@property (weak, nonatomic) IBOutlet UILabel *pctWorkCompleteLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *milestoneCell;
@property (weak, nonatomic) IBOutlet UILabel *assignedResourcesLabel;
@property (weak, nonatomic) IBOutlet UILabel *predecessorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *successorsLabel;

@end
