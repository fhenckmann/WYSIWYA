//
//  ProjectSettings.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 21/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface ProjectSettings : NSManagedObject

@property (nonatomic) BOOL autoTimeManagement;
@property (nonatomic, retain) Project *project;

@end
