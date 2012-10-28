//
//  Task.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Task, TaskAttributeAllocation, TaskResourceAllocation;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString* uid;
@property (nonatomic) int32_t duration;
@property (nonatomic) int32_t effort;
@property (nonatomic) int32_t effortComplete;
@property (nonatomic) int16_t level;
@property (nonatomic, retain) NSDate* endDate;

@property (nonatomic) BOOL isMilestone;
@property (nonatomic) BOOL hasStarted;
@property (nonatomic) BOOL isFinished;
@property (nonatomic, retain) NSDate* startDate;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic, retain) NSString * wbs;
@property (nonatomic, retain) Task *ancestor;
@property (nonatomic, retain) NSSet *attributes;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSSet *predecessors;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *roles;
@property (nonatomic, retain) NSSet *successors;

@property (nonatomic, retain) NSMutableArray* position;
@property (nonatomic, readonly, getter = isFirstChild) BOOL firstChild;
@property (nonatomic, readonly, getter = isFinished) BOOL finished;
@property (nonatomic, retain, readonly) NSString* formattedWbs;
@property (nonatomic) int pctComplete;

+ (NSString*) generateWbsFromPosition:(NSArray*)inputPosition;
- (void) updateOwnWbsFromPosition;
- (NSString*) nextTaskWbs;
- (void) reorderForDelete;
- (void) reorderForIndent;
- (void) reorderForUnindent;
- (void) reorderForInsertAfter;
- (void) indent;
- (void) unindent;

@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addAttributesObject:(TaskAttributeAllocation *)value;
- (void)removeAttributesObject:(TaskAttributeAllocation *)value;
- (void)addAttributes:(NSSet *)values;
- (void)removeAttributes:(NSSet *)values;

- (void)addChildrenObject:(Task *)value;
- (void)removeChildrenObject:(Task *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addPredecessorsObject:(Task *)value;
- (void)removePredecessorsObject:(Task *)value;
- (void)addPredecessors:(NSSet *)values;
- (void)removePredecessors:(NSSet *)values;

- (void)addResourcesObject:(TaskResourceAllocation *)value;
- (void)removeResourcesObject:(TaskResourceAllocation *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

- (void)addSuccessorsObject:(Task *)value;
- (void)removeSuccessorsObject:(Task *)value;
- (void)addSuccessors:(NSSet *)values;
- (void)removeSuccessors:(NSSet *)values;

@end
