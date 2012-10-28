//
//  Task.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 27/07/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//


#import "TaskOld.h"

@implementation TaskOld


{

    
    
}

@synthesize name = _name;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize complete = _complete;
@synthesize effort = _effort;
@synthesize pctComplete = _pctComplete;
@synthesize executionStatus = _executionStatus;
@synthesize predecessors = _predecessors;
@synthesize incompletePredecessors = _incompletePredecessors;
@synthesize successors = _successors;
@synthesize taskOwner = _taskOwner;
@synthesize duration= _duration;
@synthesize description = _description;

/*
- (id) init {
    if ( self = [super init] ) {
        _predecessors = [NSMutableArray array];
        _successors = [NSMutableArray array];
        _incompletePredecessors = [NSMutableArray array];
        _pctComplete = 0;
        _complete = NO;
    }
    return self;
}


- (void) updateIncompletePredecessors {
    [self.incompletePredecessors removeAllObjects];
    for (int i=0; i<[self.predecessors count];i++) {
        Task *tempTask = [self.predecessors objectAtIndex:i];
        if (![tempTask isComplete]) [self.incompletePredecessors addObject:tempTask];
    }
}


- (void) addPredecessor: (Task*) task {
    [self.predecessors addObject:task];
}

- (void) addSuccessor: (Task*) task {
    [self.successors addObject:task];
}


- (void) setPctComplete: (int) percentage {
    BOOL wasComplete = self.complete;
    self.pctComplete = percentage;
    self.complete = (self.pctComplete == 100);
    //if completion status changes, obtain all successors and update their "incomplete predecessors" routine
    if (wasComplete != self.complete) {
        for (int i=0; i<[self.successors count];i++) {
            [[self.successors objectAtIndex:i] updateIncompletePredecessors];
        }
    }
}

- (int) calculateExecutionStatus: (NSDate*) checkDate {
    
    int returnCode;
    BOOL allPredecessorsComplete;
    
    if (self.complete) {
        
        returnCode = COMPLETE;
        
    } else {
        
        //check if predecessors are all complete
        allPredecessorsComplete = YES;
        for (int i=0; i<[self.predecessors count];i++) {
            if (![(Task*)[self.predecessors objectAtIndex:i] isComplete]) allPredecessorsComplete = NO;
        }
        
        //check if task should have started by checkDate
        
        if ([self.startDate isEqualToDate: [self.startDate laterDate:checkDate]]) {
            
            //task should not have started yet, check if it's ready to go or not
            if (allPredecessorsComplete)
                returnCode = FUTURE_TASK_READY_TO_GO;
            else
                returnCode = FUTURE_TASK;
            
        } else {
            // check if task should have been finished by checkDate
            
            if ([self.endDate isEqualToDate: [self.endDate earlierDate:checkDate]]) {
                    
                //task should have been completed by checkDate
                if (allPredecessorsComplete)
                    returnCode = DELAYED;
                else
                    returnCode = DELAYED_WITH_PREDECESSORS_INCOMPLETE;
            } else {
              
                //task should have started, but is not due by checkDate
                if (allPredecessorsComplete)
                    returnCode = IN_PROGRESS;
                else
                    returnCode = IN_PROGRESS_WITH_PREDECESSORS_INCOMPLETE;
            }
        }
    }
    
    return returnCode;
    
}
 */


@end
