//
//  Task.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "Task.h"
#import "Project.h"
#import "Task.h"
#import "TaskAttributeAllocation.h"
#import "TaskResourceAllocation.h"
#import "Role.h"
#import "Resource.h"

@interface Task()

@property (readonly) int lastLevelPosition;

- (void) reorderUpwards;
- (void) reorderDownwards;


@end

@implementation Task

{

}

@dynamic duration;
@dynamic dynamicScheduling;
@dynamic effort;
@dynamic effortComplete;
@dynamic endDate;
@dynamic isMilestone;
@dynamic hasStarted;
@dynamic isFinished;
@dynamic level;
@dynamic startDate;
@dynamic taskDescription;
@dynamic taskName;
@dynamic uid;
@dynamic wbs;
@dynamic ancestor;
@dynamic attributes;
@dynamic children;
@dynamic predecessors;
@dynamic project;
@dynamic roles;
@dynamic successors;


@synthesize position = _position;
@synthesize firstChild = _firstChild;
@synthesize lastLevelPosition = _lastLevelPosition;
@synthesize formattedWbs = _formattedWbs;
@synthesize finished = _finished;
@synthesize assignedTo = _assignedTo;


+ (NSString*)generateWbsFromPosition:(NSArray *)inputPosition
{
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    int i = 0;
    while (i<20) {
        int tempInt = [(NSNumber*)[inputPosition objectAtIndex:i] intValue];
        [tmpArray addObject:[NSString stringWithFormat:@"%03d",tempInt]];
         i++;

    }
    return [tmpArray componentsJoinedByString:@"."];
    
}

- (NSArray*)position
{
    if (_position) {
        
        NSLog(@"Request for task.position for object %@. Position is not NULL.", self.taskName);
        
    } else {
        
        NSLog(@"Generating position from WBS %@", self.wbs);
        NSMutableArray* wbsComponents = [NSMutableArray arrayWithArray:[self.wbs componentsSeparatedByString:@"."]];
        _position = [NSMutableArray array];

        for (int i=0; i < 20; i++) {
            
            NSNumber* wbsPart = [NSNumber numberWithInt:[[wbsComponents objectAtIndex:i] intValue]];
            [_position addObject:wbsPart];
            
        }
    }
    
    return _position;
    
}

- (int) lastLevelPosition
{

    int lastLevelIndex = self.level-1;
    return [(NSNumber*)[self.position objectAtIndex:lastLevelIndex] intValue];

    
}


- (BOOL) isFirstChild
{
    
    return (self.lastLevelPosition==1);
    
}


//changing the percentage complete will update the effort complete, as pctComplete is not stored in managed object

- (void) setPctComplete:(int) percentage
{
    
    self.effortComplete = (int) (self.effort * percentage);
    
}


- (int) pctComplete
{
    
    if (self.effort > 0) {
        
        return self.effortComplete / self.effort;
        
    } else {
        
        return 0;
        
    }
    
}


- (NSString*) formattedWbs
{
    if (_formattedWbs) {
        
        return _formattedWbs;
        
    } else {
        
        NSMutableArray* tempArray = [NSMutableArray array];
        int i = 0;
        while (i<20) {
            int tempInt = [(NSNumber*)[self.position objectAtIndex:i] intValue];
            if (tempInt) {
                [tempArray addObject:[NSString stringWithFormat:@"%d",tempInt]];
                i++;
            } else {
                i = 20;
            }
        }
        
        _formattedWbs = [tempArray componentsJoinedByString:@"."];
        
        return _formattedWbs;
        
    }
    
    
}

- (NSString*) assignedTo
{
    
    if (_assignedTo) {
        
        return _assignedTo;
        
    } else {
     
        for (Role* role in self.roles) {
            
            //check if role has resources assigned. If so, add resources to assignedTo, otherwise use role name
            
            if (role.resources.count) {
                
                for (Resource* resource in role.resources) {
                    
                    _assignedTo = [NSString stringWithFormat:@"%@, %@ %@", _assignedTo, resource.firstName, resource.lastName];
                }
                
            } else {
                
                _assignedTo = [NSString stringWithFormat:@"%@, %@", _assignedTo, role.roleName];
            }
            
            
        }
        
        return _assignedTo;
        
    }
    
}

- (NSString*) nextTaskWbs
{
    //check whether current task is the master task. If not, calculate next WBS, otherwise just return wbs for 1.1
    
    if (self.level > 1) {
        
        NSMutableArray* nextTaskPosition = [NSMutableArray arrayWithArray:self.position];
        int lastLevelPos = self.lastLevelPosition + 1;
        NSNumber* lastLevelPosObject = [NSNumber numberWithInt:lastLevelPos];
        [nextTaskPosition replaceObjectAtIndex:(self.level-1) withObject:lastLevelPosObject];
        NSString* newWBS = [Task generateWbsFromPosition:nextTaskPosition];
        NSLog(@"We are creating a WBS for a new item and that WBS is %@", newWBS);
        return [Task generateWbsFromPosition:nextTaskPosition];
        
    } else {
        
        return(@"001.001.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000");
        
    }

}

- (void) updateOwnWbsFromPosition {
    
    self.wbs = [Task generateWbsFromPosition:self.position];
    _formattedWbs = nil;
    
}

- (void) updatePosition:(int) positionLevel increasePosition:(BOOL) isItAdd
{
    int arrayIndex = positionLevel - 1;
    
    //update item itself
    int tempInt = [(NSNumber*)[self.position objectAtIndex:arrayIndex] intValue];
    
    if (isItAdd) {
        tempInt++;
    } else {
        tempInt--;
    }
    
    [self.position replaceObjectAtIndex:arrayIndex withObject:[NSNumber numberWithInt:tempInt]];
    [self updateOwnWbsFromPosition];
    
    //update children
    NSSet* taskChildren = [NSSet setWithSet:self.children];
    
    for (Task* child in taskChildren) {
        
        [child updatePosition:positionLevel increasePosition:isItAdd];
        
    }
}



- (void) reorderUpwards
{
    
    //retrieve all siblings
    Task* ancestor = self.ancestor;
    NSSet* children = [NSSet setWithSet:ancestor.children];
    
    //for all items with higher position int, execute updatePositionAfterDelete
    for (Task* child in children) {
        
        if (child.lastLevelPosition > self.lastLevelPosition) {
            
            [child updatePosition:(self.level) increasePosition:NO];
            
        }
        
    }

}

- (void) reorderDownwards
{
    
    //retrieve all siblings - or children if current task is master task
    Task* ancestor = (self.level==1)? self : self.ancestor;
    NSSet* children = [NSSet setWithSet:ancestor.children];
     
    int criticalLevelPos = (self.level==1)? 0 : self.lastLevelPosition;
    
    //for all items that follow the "critical level position", update the WBS
    //and, if "change" is YES, set the current task to be their new ancestor, as we'll unindent the current task.
    int levelToChange = (self.level==1)? 2 : self.level;
    
    for (Task* child in children) {
        
        if (child.lastLevelPosition > criticalLevelPos) {
            
            [child updatePosition:levelToChange increasePosition:YES];

        }
        
    }
    
}

- (void) siblingsToChildren
{
    
    //retrieve task and all its siblings
    Task* ancestor = self.ancestor;
    NSLog(@"Ancestor of unindent task is %@", ancestor.wbs);
    NSSet* siblings = [NSSet setWithSet:ancestor.children];
    NSLog(@"Number of siblings: %d", siblings.count);
    //get the number of children where we stack the siblings behind
    int numberOfChildren = [self.children count];
    NSLog(@"Children: %d", numberOfChildren);
    //get the number that determines what siblings are "younger"
    int criticalLevelPos = self.lastLevelPosition;
    NSLog(@"Critical level pos: %d", criticalLevelPos);
    
    int levelToChange = self.level;
    NSLog(@"Level to chagne: %d", levelToChange);
    
    for (Task* sibling in siblings) {
        
        NSLog(@"checking sibling %@", sibling.wbs);
        
        if (sibling.lastLevelPosition > criticalLevelPos) {
            
            NSLog(@"Yes, he's a younger sibling.");
            
            sibling.ancestor = self;
            int siblingNumber = sibling.lastLevelPosition - criticalLevelPos;
            [sibling wbsRightPushSiblingsFromLevel:levelToChange withOffset:(numberOfChildren + siblingNumber) andAncestorLevel:criticalLevelPos];
                        
        }
        
    }
    
    
}


- (void) reorderForDelete
{    
    [self reorderUpwards];
}


- (void) reorderForInsertAfter
{
    [self reorderDownwards];
}


- (void) reorderForIndent
{
    [self reorderUpwards];
}


- (void) reorderForUnindent
{
    [self reorderDownwards];
}


- (void) wbsRightPushFromLevel:(int)hierarchyLevel
{
    //change all of the 20 levels that are to the right of the original object's hierarchy level
    for (int i=19; i > hierarchyLevel; i--) {
        
        [self.position replaceObjectAtIndex:(i) withObject:[self.position objectAtIndex:(i-1)]];
                
    }
    
    //insert a position "1" for the new / increased hierarchy level
    [self.position replaceObjectAtIndex:hierarchyLevel withObject:[NSNumber numberWithInt:1]];
     
    //move the original hierarchy level one up
    NSNumber* levelPosToBeChanged = (NSNumber*)[self.position objectAtIndex:(hierarchyLevel-1)];
    int pos = [levelPosToBeChanged intValue];
    pos--;
    [self.position replaceObjectAtIndex:(hierarchyLevel-1) withObject:[NSNumber numberWithInt:pos]];
    
    //update wbs from position and set new level
    [self updateOwnWbsFromPosition];
    self.level++;
    
    //do the same for all children
    NSSet* loopChildren = [NSSet setWithSet:self.children];
    
    for (Task* child in loopChildren) {
        
        [child wbsRightPushFromLevel:hierarchyLevel];
        
    }
}


- (void) wbsRightPushSiblingsFromLevel:(int) hierarchyLevel withOffset:(int) offset andAncestorLevel:(int) ancestorLevel
{
    //change all of the 20 levels that are to the right of the original object's hierarchy level
    for (int i=19; i > hierarchyLevel; i--) {
        
        [self.position replaceObjectAtIndex:(i) withObject:[self.position objectAtIndex:(i-1)]];
        
    }
    
    //insert a position "offset" for the new / increased hierarchy level
    [self.position replaceObjectAtIndex:hierarchyLevel withObject:[NSNumber numberWithInt:offset]];
    
    //change the sibling level to be identical to the original task number
    [self.position replaceObjectAtIndex:(hierarchyLevel-1) withObject:[NSNumber numberWithInt:ancestorLevel]];
    
    //update wbs from position and set new level
    [self updateOwnWbsFromPosition];
    self.level++;
    
    //do the same for all children
    NSSet* loopChildren = [NSSet setWithSet:self.children];
    
    for (Task* child in loopChildren) {
        
        [child wbsRightPushSiblingsFromLevel:hierarchyLevel withOffset:offset andAncestorLevel:ancestorLevel];
        
    }
}


- (void) wbsLeftPullFromLevel:(int)hierarchyLevel
{
    //update all of the first 19 levels that are at the same or to the right of the original object's hierarchy level
    for (int i=hierarchyLevel; i < 20; i++) {
        
        [self.position replaceObjectAtIndex:(i-1) withObject:[self.position objectAtIndex:i]];
        
    }
    
    //Position 20 is always 0 after unindent
    [self.position replaceObjectAtIndex:19 withObject:[NSNumber numberWithInt:0]];
    
    //increase the position in new hierarchy level
    NSNumber* levelPosToBeChanged = (NSNumber*)[self.position objectAtIndex:hierarchyLevel-2];
    int pos = [levelPosToBeChanged intValue];
    pos++;
    [self.position replaceObjectAtIndex:hierarchyLevel-2 withObject:[NSNumber numberWithInt:pos]];
    
    //update wbs from position and set new level
    [self updateOwnWbsFromPosition];
    self.level--;
    
    //do the same for all children
    NSSet* loopChildren = [NSSet setWithSet:self.children];
    
    for (Task* child in loopChildren) {
        
        [child wbsLeftPullFromLevel:hierarchyLevel];
        
    }
    
}

- (Task*) getChildWithLastPosition:(int) lastPosition
{
    
    NSSet* loopChildren = [NSSet setWithSet:self.children];
    
    for (Task* child in loopChildren) {
        
        if (child.lastLevelPosition == lastPosition)
            
            return child;
        
    }
    
    return nil;
    
}


- (void) indent
{
    
    //update WBS of all younger siblings and their descendants
    [self reorderForIndent];
    
    //setting new ancestor
    self.ancestor = [self.ancestor getChildWithLastPosition:([self lastLevelPosition]-1)];
    NSLog(@"Last level of ancestor is %d", self.ancestor.lastLevelPosition);
    
    //check how many children the new ancestor already has
    int currentNumberOfChildren = self.ancestor.children.count;
    
    //update level and wbs of task and all its descendants by pushing the position data to the right
    [self wbsRightPushSiblingsFromLevel:self.level withOffset:(currentNumberOfChildren) andAncestorLevel:self.ancestor.lastLevelPosition] ;
       
}


- (void) unindent
{
    
    //the tasks's former younger siblings will become children, added after the already existing children
    [self siblingsToChildren];
    
    //update WBS of all of ancestor's younger siblings and their descendants - identical if an insert on ancestor would be performed
    [self.ancestor reorderForUnindent];
    
    //set new ancestor
    self.ancestor = self.ancestor.ancestor;
    
    //update level and wbs of task and all its descendents by pulling the position data to the left
    [self wbsLeftPullFromLevel:self.level];
    
}


- (BOOL) isAncestor:(Task *)potentialHeir
{
    
    if ([potentialHeir.formattedWbs rangeOfString:self.formattedWbs].location != 0) {
        
        return NO;
        
    } else {
        
        return YES;
    }
    
}


- (BOOL) canIndent
{
    
    if ((self.isFirstChild) || (self.level==20)) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
    
}


- (BOOL) canUnindent
{
    
    if (self.level>2) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}


@end
