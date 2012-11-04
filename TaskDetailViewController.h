//
//  TaskDetailViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *wbsLabel;
@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UITextView *taskDetailsField;
@property (weak, nonatomic) IBOutlet UILabel *pctCompleteLabel;
@property (weak, nonatomic) IBOutlet UISlider *pctCompleteSlider;
@property (weak, nonatomic) IBOutlet UIButton *hasStartedButton;
@property (weak, nonatomic) IBOutlet UIButton *isCompleteButton;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTypeLabel;




- (IBAction)updatePctComplete:(id)sender;
- (IBAction)clickHasStarted:(id)sender;
- (IBAction)clickIsComplete:(id)sender;
- (IBAction)showSchedule:(id)sender;
- (IBAction)showResources:(id)sender;
- (IBAction)showPredecessors:(id)sender;



@end
