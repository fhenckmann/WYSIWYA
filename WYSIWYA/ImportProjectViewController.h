//
//  ImportProjectViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 5/09/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataController;

@protocol ImportProjectViewControllerDelegate;


@interface ImportProjectViewController : UIViewController

@property (weak, nonatomic) id <ImportProjectViewControllerDelegate> delegate;

@end

@protocol ImportProjectViewControllerDelegate <NSObject>

- (void)popoverDidComplete;

@end