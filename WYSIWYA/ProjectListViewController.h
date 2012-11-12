//
//  ProjectListViewController.h
//  Working Title
//
//  Created by Fabian Henckmann on 10/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteDataController.h"

@class ProjectDetailsViewController;
@class CoreDataController;
@class Project;

@protocol ProjectListViewControllerDelegate;

@interface ProjectListViewController : UITableViewController <RemoteDataControllerDelegate>

@property (weak, nonatomic) id <ProjectListViewControllerDelegate> delegate;
@property (strong, nonatomic) UIBarButtonItem* cancelButton;
@property (strong, nonatomic) UIBarButtonItem* selectButton;
@property (strong, nonatomic) UIBarButtonItem* cancelDeleteButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceSelector;

- (IBAction)cancel:(id)sender;
- (IBAction)selectProject:(id)sender;
- (IBAction)invokeEditMode:(id)sender;
- (IBAction)selectListSource:(id)sender forEvent:(UIEvent *)event;

- (void) updateProgress:(NSNumber*)progress;
- (void) processResults:(NSArray*)results;
- (void) handleError:(NSString*)error;


@end

@protocol ProjectListViewControllerDelegate <NSObject>

- (void) popoverDidComplete;
- (void) loadProject;

@end