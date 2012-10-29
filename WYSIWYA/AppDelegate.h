//
//  AppDelegate.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 27/07/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataController;
@class SharedData;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SharedData* globalStore;


@end
