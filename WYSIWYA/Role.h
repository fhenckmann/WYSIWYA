//
//  Role.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 12/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Resource, Role, TaskResourceAllocation;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSNumber * isInternal;
@property (nonatomic, retain) NSString * roleName;
@property (nonatomic, retain) Role *ancestor;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *resources;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Role (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Role *)value;
- (void)removeChildrenObject:(Role *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

- (void)addTasksObject:(TaskResourceAllocation *)value;
- (void)removeTasksObject:(TaskResourceAllocation *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
