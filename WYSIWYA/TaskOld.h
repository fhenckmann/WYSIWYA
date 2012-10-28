//
//  Task.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 27/07/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Resource;

static const int COMPLETE = 1;
static const int IN_PROGRESS=2;
static const int IN_PROGRESS_WITH_PREDECESSORS_INCOMPLETE=3;
static const int DELAYED=4;
static const int DELAYED_WITH_PREDECESSORS_INCOMPLETE=5;
static const int FUTURE_TASK=6;
static const int FUTURE_TASK_READY_TO_GO=7;


@interface TaskOld : NSObject

@property (nonatomic,readwrite) NSMutableString* name;
@property (nonatomic,readwrite) NSDate* startDate;
@property (nonatomic,readwrite) NSDate* endDate;
@property (nonatomic,readwrite,getter=isComplete) BOOL complete;
@property (nonatomic,readwrite) double effort;
@property (nonatomic,readwrite) int pctComplete;
@property (nonatomic,readwrite) int executionStatus;
@property (nonatomic,readwrite) NSMutableArray* predecessors;
@property (nonatomic,readwrite) NSMutableArray* successors;
@property (nonatomic,readwrite) NSMutableArray* incompletePredecessors;
@property (nonatomic,readwrite) Resource* taskOwner;
@property (nonatomic,readwrite) double duration;
@property (nonatomic,readwrite) NSMutableString* description;

/*

- (int) calculateExecutionStatus: (NSDate*) projectDate;
- (void) addPredecessor: (Task*) task;
- (void) addSuccessor: (Task*) task;
- (void) setPctComplete:(int)pctComplete;
- (void) updateIncompletePredecessors;
*/

@end
