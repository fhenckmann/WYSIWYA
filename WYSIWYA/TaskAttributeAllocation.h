//
//  TaskAttributeAllocation.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attribute, Task;

@interface TaskAttributeAllocation : NSManagedObject

@property (nonatomic, retain) NSString * attributeValue;
@property (nonatomic, retain) Attribute *attribute;
@property (nonatomic, retain) Task *task;

@end
