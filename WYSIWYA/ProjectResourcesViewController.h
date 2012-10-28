//
//  ProjectResourcesViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ProjectResourcesDetailViewController;

@interface ProjectResourcesViewController : UITableViewController <UISplitViewControllerDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) NSManagedObject* project;
@property (strong, nonatomic) ProjectResourcesDetailViewController* detailViewController;
//@property (strong, nonatomic) UISplitViewController* splitViewController;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
