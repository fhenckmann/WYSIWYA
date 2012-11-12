//
//  LoadProgressViewController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "LoadProgressViewController.h"

@interface LoadProgressViewController ()

@end

@implementation LoadProgressViewController

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

- (IBAction)cancelLoad:(id)sender {
    
    
}


- (void)viewDidUnload
{
    
    [self setProgressBar:nil];
    [super viewDidUnload];

}

@end
