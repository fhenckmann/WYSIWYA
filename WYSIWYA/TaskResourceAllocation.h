//
//  TaskResourceAllocation.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resource, Task;

@interface TaskResourceAllocation : NSManagedObject

@property (nonatomic) int16_t pctAllocated;
@property (nonatomic, retain) Resource *resource;
@property (nonatomic, retain) Task *task;

@end
