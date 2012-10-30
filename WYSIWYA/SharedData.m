//
//  SharedData.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 29/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "SharedData.h"
#import "Project.h"
#import "CoreDataController.h"
#import <CoreData/CoreData.h>

@implementation SharedData

static SharedData* _sharedInstance;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tempObjectContext = _tempObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tempStoreCoordinator = _tempStoreCoordinator;
@synthesize projectController = _projectController;
@synthesize remoteProjectController = _remoteProjectController;
@synthesize taskController = _taskController;

+ (SharedData*) sharedInstance
{
	if (!_sharedInstance) {
        
		_sharedInstance = [[SharedData alloc] init];
        
	}
    
	return _sharedInstance;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//returns-creates CoreDataController instance with list of all locally stored projects

- (CoreDataController*) projectController
{
    
    if (_projectController != nil) {
        
        return _projectController;
        
    }
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified" ascending:NO];
    NSArray* sortDescriptors = @[sortDescriptor];
    _projectController = [[CoreDataController alloc] initWithEntity:@"Project" context:self.managedObjectContext sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:nil fetchSize:20 cacheName:nil];
    
    return _projectController;
    
}


// deletes the current project controller and then returns a fresh one (by calling the local projectController property method)

- (CoreDataController*) freshProjectController
{
    
    _projectController = nil;
    
    return self.projectController;
    
}


// returns-creates a CoreDataController instance from the temporary persistence store

- (CoreDataController*) remoteProjectController
{
    
    if (_remoteProjectController != nil) {
        
        return _remoteProjectController;
        
    }
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified" ascending:NO];
    NSArray* sortDescriptors = @[sortDescriptor];
    _remoteProjectController = [[CoreDataController alloc] initWithEntity:@"Project" context:self.tempObjectContext sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:nil fetchSize:20 cacheName:nil];
    return _remoteProjectController;
    
}

// deletes current remote project controller and returns a new one (through calling local remoteProjectController property method)

- (CoreDataController*) freshRemoteController
{
    
    _remoteProjectController = nil;
    
    return self.remoteProjectController;
    
}


// returns-creates a CoreDataController instance with all tasks of currently active project

- (CoreDataController*) taskController
{
    
    if (_taskController != nil) {
        
        return _taskController;
        
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wbs" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(project == %@)", self.activeProject];
    _taskController = [[CoreDataController alloc] initWithEntity:@"Task" context:self.managedObjectContext sortDescriptor:sortDescriptors sectionNameKeyPath:nil predicate:predicate fetchSize:100 cacheName:nil];
    return _taskController;
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)tempObjectContext
{
    if (_tempObjectContext != nil) {
        return _tempObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self tempStoreCoordinator];
    if (coordinator != nil) {
        _tempObjectContext = [[NSManagedObjectContext alloc] init];
        [_tempObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _tempObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSLog(@"Persistent Store URL for Core Data is %@", [storeURL path]);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSPersistentStoreCoordinator *)tempStoreCoordinator
{
    if (_tempStoreCoordinator != nil) {
        return _tempStoreCoordinator;
    }
    
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tempStore.sqlite"];
    
    NSLog(@"Temporary Store URL for Core Data is %@", [storeURL path]);
    
    NSError *error = nil;
    _tempStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_tempStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _tempStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
