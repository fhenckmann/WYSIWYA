//
//  ProjectSettingsViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 6/09/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataController;
@class Project;

@interface ProjectSettingsViewController : UIViewController

@property (strong, nonatomic) CoreDataController* dataController;
@property (strong, nonatomic) Project* activeProject;


@end
