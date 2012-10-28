//
//  Project.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "Project.h"


@implementation Project

@dynamic uid;
@dynamic taskUidCounter;
@dynamic creationDate;
@dynamic lastModified;
@dynamic projectDescription;
@dynamic projectFinish;
@dynamic projectName;
@dynamic projectStart;
@dynamic resources;
@dynamic roles;
@dynamic settings;
@dynamic tasks;

@synthesize numberOfTasks = _numberOfTasks;


- (int) numberOfTasks

{
    
    if (_numberOfTasks) {
        
        return _numberOfTasks;
        
    }
    
    _numberOfTasks = [self.tasks count];
    
    return _numberOfTasks;
    
}

@end
