//
//  SharedData.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 29/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@class CoreDataController;


@interface SharedData : NSObject

@property (nonatomic, retain) Project* activeProject;
@property (nonatomic, retain) CoreDataController* projectController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *tempObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *tempStoreCoordinator;
@property (readonly, strong, nonatomic) CoreDataController *dataController;

+ (SharedData*) sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
