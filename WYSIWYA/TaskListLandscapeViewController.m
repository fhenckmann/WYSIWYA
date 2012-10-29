//
//  TaskListLandscapeViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 29/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "TaskListLandscapeViewController.h"

@interface TaskListLandscapeViewController ()

@end

@implementation TaskListLandscapeViewController

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
    
    [self.navigationItem setTitle:@"haha"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
