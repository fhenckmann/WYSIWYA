//
//  ProjectDataController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 10/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@protocol CoreDataControllerDelegate;

@interface CoreDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id <CoreDataControllerDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, getter = isEmpty) BOOL empty;

- (id) initWithEntity:(NSString*)entity context:(NSManagedObjectContext*)context sortDescriptor:(NSArray*)sortDescriptors sectionNameKeyPath:(NSString*)sectionNameKeyPath predicate:(NSPredicate*)predicate fetchSize:(int)fetchSize cacheName:(NSString*) cacheName;
- (NSUInteger)countOfList;
- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfObjectsInSection: (int) section;
- (NSManagedObject*) objectInListAtIndex: (NSUInteger) theIndex;
- (NSManagedObject*) objectAtIndexPath: (NSIndexPath*) indexPath;
- (NSManagedObject*) objectFollowing: (NSManagedObject*) object;
- (NSManagedObject*) objectPreceding: (NSManagedObject*) object;
- (NSIndexPath*) indexPathOfObject: (NSManagedObject*) object;
- (NSManagedObject*) createObject: (NSString*) entity;
- (void) rollback;
- (NSError*) saveContext;
- (NSError*) deleteObject: (NSManagedObject*) object;
- (NSError*) deleteAll;
- (BOOL) hasChanges;

@end

@interface CoreDataController (protected)

- (NSFetchedResultsController *)fetchedResultsController;
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
- (void) addObjectWithKeys:(NSArray *)keys values:(NSArray *)values;


@end

@protocol CoreDataControllerDelegate <NSObject>

- (void) insertSections:(NSIndexSet*)sectionIndex;
- (void) deleteSections:(NSIndexSet*)sectionIndex;
- (void) insertRowAtIndexPath:(NSIndexPath*)indexPath;
- (void) deleteRowAtIndexPath:(NSIndexPath*)indexPath;
- (void) configureCellAtIndexPath:(NSIndexPath*)indexPath;
- (void) beginUpdates;
- (void) endUpdates;

@end
