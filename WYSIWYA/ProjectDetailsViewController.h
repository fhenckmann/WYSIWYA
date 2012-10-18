//
//  ProjectDetailsViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 12/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class WYSIWIAMasterViewController;
@class Project;

@protocol ProjectDetailsViewControllerDelegate;


@interface ProjectDetailsViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Project* project;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) WYSIWIAMasterViewController* masterViewController;
@property (strong, nonatomic) UIImageView* backgroundView;
@property (weak, nonatomic) id <ProjectDetailsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTaskUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfTasksLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectEndLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)openProject:(id)sender;


@end

@protocol ProjectDetailsViewControllerDelegate <NSObject>

- (void)loadTabBarSegue;

@end