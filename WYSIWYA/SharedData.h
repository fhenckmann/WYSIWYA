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
@property (nonatomic, readonly, retain) CoreDataController* projectController;
@property (nonatomic, readonly, retain) CoreDataController* taskController;
@property (nonatomic, readonly, retain) CoreDataController* remoteProjectController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *tempObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *tempStoreCoordinator;

+ (SharedData*) sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (CoreDataController*) freshProjectController;
- (CoreDataController*) freshRemoteController;

@end
