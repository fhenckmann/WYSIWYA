//
//  ProjectStartScreenViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 5/09/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateProjectViewController.h"
#import "ProjectListViewController.h"
#import "ImportProjectViewController.h"
@class CoreDataController;

@interface ProjectStartScreenViewController : UIViewController <CreateProjectViewControllerDelegate, ProjectListViewControllerDelegate, ImportProjectViewControllerDelegate>

@property (strong,nonatomic) CoreDataController* dataController;
@property (strong, nonatomic) Project* activeProject;

- (void) loadProject:(Project *)selectedProject;
- (void) popoverDidComplete;

@end