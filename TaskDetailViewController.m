//
//  TaskDetailViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWbsLabel:nil];
    [self setTaskNameField:nil];
    [self setTaskDetailsField:nil];
    [self setPctCompleteLabel:nil];
    [self setPctCompleteSlider:nil];
    [self setHasStartedButton:nil];
    [self setIsCompleteButton:nil];
    [self setClickHasStarted:nil];
    [self setWorkLabel:nil];
    [self setFromDateLabel:nil];
    [self setToDateLabel:nil];
    [self setScheduleTypeLabel:nil];
    [self setShowPredecessors:nil];
    [super viewDidUnload];
}
- (IBAction)updatePctComplete:(id)sender {
}

- (IBAction)clickHasStarted:(id)sender {
}

- (IBAction)clickIsComplete:(id)sender {
}

- (IBAction)showSchedule:(id)sender {
}

- (IBAction)showResources:(id)sender {
}

- (IBAction)showPredecessors:(id)sender {
}
@end
