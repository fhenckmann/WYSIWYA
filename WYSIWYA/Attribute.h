//
//  Attribute.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Task.h"


@interface Attribute : NSManagedObject

@property (nonatomic, retain) NSString * attributeName;
@property (nonatomic, retain) NSString * possibleValues;
@property (nonatomic, retain) NSMutableSet *tasks;
@end

@interface Attribute (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
