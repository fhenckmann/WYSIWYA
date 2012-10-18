//
//  Resource.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Project;
@class Task;

@interface Resource : NSManagedObject

@property (nonatomic, retain) NSString * eMailAddress;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSMutableSet *projects;
@property (nonatomic, retain) NSMutableSet *tasks;
@end

@interface Resource (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
