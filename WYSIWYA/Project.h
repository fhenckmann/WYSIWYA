//
//  Project.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resource;
@class Task;
@class ProjectSettings;


@interface Project : NSManagedObject

@property (nonatomic, retain) NSString* uid;
@property (nonatomic) int16_t taskUidCounter;
@property (nonatomic, retain) NSDate* creationDate;
@property (nonatomic, retain) NSDate* lastModified;
@property (nonatomic, retain) NSString* projectDescription;
@property (nonatomic, retain) NSDate* projectFinish;
@property (nonatomic, retain) NSString* projectName;
@property (nonatomic, retain) NSDate* projectStart;
@property (nonatomic, retain) NSArray* resources;
@property (nonatomic, retain) NSArray* roles;
@property (nonatomic, retain) ProjectSettings* settings;
@property (nonatomic, retain) NSArray* tasks;

@property (nonatomic) int numberOfTasks;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;
@end
