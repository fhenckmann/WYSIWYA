//
//  ProjectDataController.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 10/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "CoreDataController.h"


@interface CoreDataController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSString* entityName;
@property (strong, nonatomic) NSArray* sortDescriptors;
@property (strong, nonatomic) NSString* sectionNameKeyPath;
@property (strong, nonatomic) NSPredicate* predicate;
@property (strong, nonatomic) NSString* cacheName;
@property (nonatomic) int fetchSize;

@end

@implementation CoreDataController

{
    NSString *_documentsDirectory;
    NSArray *_directoryContents;
    BOOL _sectioned;
}

@synthesize empty = _empty;
@synthesize delegate = _delegate;
@synthesize entityName = _entityName;
@synthesize sortDescriptors = _sortDescriptors;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize predicate = _predicate;
@synthesize fetchSize = _fetchSize;
@synthesize cacheName = _cacheName;


- (id) initWithEntity:(NSString*)entity context:(NSManagedObjectContext*)context sortDescriptor:(NSArray*)sortDescriptors sectionNameKeyPath:(NSString*)sectionNameKeyPath predicate:(NSPredicate*)predicate fetchSize:(int)fetchSize cacheName:(NSString*) cacheName
{
    if (self = [super init]) {
        
        self.entityName = entity;
        self.sortDescriptors = sortDescriptors;
        self.sectionNameKeyPath = sectionNameKeyPath;
        self.predicate = predicate;
        self.fetchSize = fetchSize;
        self.cacheName = cacheName;
        self.managedObjectContext = context;
        
        //set _sectioned flag if the data set is sectioned
        _sectioned = (sectionNameKeyPath)? YES : NO;
        
        return self;
        
    }
    
    return nil;
    
}


- (NSManagedObject*) objectInListAtIndex:(NSUInteger)theIndex
{
    
    return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:theIndex inSection:0]];
    
}

- (NSManagedObject*) objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSManagedObject*) objectFollowing: (NSManagedObject*) object
{
        
    NSIndexPath* objectPath = [self.fetchedResultsController indexPathForObject:object];
    NSIndexPath* newIndexPath;
    
    int objectRow = objectPath.row;
    int objectSection = objectPath.section;
    
    int rowsInSection = [self numberOfObjectsInSection:objectSection];
    
    if (objectRow < rowsInSection-1) {
        
        //easiest case - object wasn't last in its section
        newIndexPath = [NSIndexPath indexPathForRow:(objectRow+1) inSection:objectSection];
        
    } else if (objectSection < ([self numberOfSections]-1)) {
        
        //object was last in its section, but there are more setions behind it
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:(objectSection+1)];
        
    } else {
        
        //object was the last, return itself
        newIndexPath = objectPath;
    }
    
    return [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    
}


- (NSManagedObject*) objectPreceding:(NSManagedObject *)object
{
    
    NSLog(@"objectPreceding method called for object %@", [object valueForKey:@"wbs"]);
    NSIndexPath* objectPath = [self.fetchedResultsController indexPathForObject:object];
    NSIndexPath* newIndexPath;
    
    int objectRow = objectPath.row;
    int objectSection = objectPath.section;
    
    if (objectRow > 0) {
        
        //easiest case - object wasn't first in its section
        NSLog(@"Predecessor is in the same section.");
        newIndexPath = [NSIndexPath indexPathForRow:(objectRow-1) inSection:objectSection];
        
    } else if (objectSection > 0) {
        
        //object was first in its section, but there are more setions before it
        NSLog(@"Predecessor is in the section before.");
        int lastRowInPreviousSection = [self numberOfObjectsInSection:(objectSection-1)]-1;
        newIndexPath = [NSIndexPath indexPathForRow:lastRowInPreviousSection inSection:(objectSection-1)];
        
    } else {
        NSLog(@"Predecessor does not exist, returning same object.");
        //object was the first object, return itself
        newIndexPath = objectPath;
    }
    
    return [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    
}


- (NSIndexPath*) indexPathOfObject:(NSManagedObject *)object
{
    
    return [self.fetchedResultsController indexPathForObject:object];
    
}


- (NSUInteger) countOfList
{
    return [[self.fetchedResultsController fetchedObjects]count];
}

- (NSUInteger) numberOfSections
{
    
    return [[self.fetchedResultsController sections] count];
    
}

- (NSUInteger) numberOfObjectsInSection:(int)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"Core Data Controller method 'numberOfObjectsInSection' called for section %d. Will return %d rows.", section, [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (BOOL) isEmpty
{
    _empty = ([[self.fetchedResultsController fetchedObjects]count]==0);
    
    NSLog (@"The fetchedREsultsController brought back objects:%d", [[self.fetchedResultsController fetchedObjects]count]);
    return _empty;
}

- (NSError*) deleteAll
{
    
    NSArray* allObjects = [self.fetchedResultsController fetchedObjects];
    
    for (NSManagedObject* object in allObjects) {
        
        [self.managedObjectContext deleteObject:object];
        
    }
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSLog(@"Crash in CoreDataController - save afer deleteAll");
        return error;
        
    } else {
        
        return nil;
    }
    
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:self.fetchSize];
    [fetchRequest setSortDescriptors:self.sortDescriptors];
    [fetchRequest setPredicate:self.predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:self.sectionNameKeyPath cacheName:self.cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSLog(@"Crash during fetchedREsultsController");
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.delegate insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.delegate deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.delegate insertRowAtIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.delegate deleteRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.delegate configureCellAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.delegate deleteRowAtIndexPath:indexPath];
            [self.delegate insertRowAtIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate endUpdates];
    
}

- (void) addObjectWithKeys:(NSArray *)keys values:(NSArray *)values
{

    NSEntityDescription* entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject* newObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];

    for (int i=0; i<[keys count];i++) {
        [newObject setValue:[keys objectAtIndex:i] forKey:[values objectAtIndex:i]];
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSLog(@"Crash in CoreDataController");
        abort();
    }
}

- (NSManagedObject*) createObject:(NSString*)entity
{
    return [NSEntityDescription
            
            insertNewObjectForEntityForName:entity
            
            inManagedObjectContext:self.managedObjectContext];
}

- (NSError*) saveContext
{
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSLog(@"Crash in CoreDataController - save");
        return error;
        
    } else {
        NSLog(@"Saved context: %@", [self.managedObjectContext description]);
        return nil;
    }
    
}

- (void) rollback
{
    
    // roll back to last saved state, discarding all changes
    
    [self.managedObjectContext rollback];
    
}

- (NSError*) deleteObject:(NSManagedObject *)object
{
    
    [self.managedObjectContext deleteObject:object];
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSLog(@"Crash in CoreDataController - save afer delete");
        return error;
        
    } else {
        
        return nil;
    }
    
}



@end
