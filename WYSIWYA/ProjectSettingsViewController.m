//
//  ProjectSettingsViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 6/09/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "ProjectSettingsViewController.h"

@interface ProjectSettingsViewController ()

@end

@implementation ProjectSettingsViewController

@synthesize activeProject = _activeProject;
@synthesize dataController = _dataController;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
