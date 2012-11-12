//
//  CreateProjectViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 11/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataController;
@class Project;

@protocol CreateProjectViewControllerDelegate;

@interface CreateProjectViewController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate>


@property (weak, nonatomic) id <CreateProjectViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *inputProjectName;
@property (weak, nonatomic) IBOutlet UITextView *inputProjectDescription;
@property (weak, nonatomic) IBOutlet UITextField *inputStartDate;
@property (weak, nonatomic) IBOutlet UITextField *inputEndDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


- (IBAction)dateChanged:(id)sender;
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;
- (IBAction)cancel:(id)sender;
- (IBAction)createProject:(id)sender;

@end

@protocol CreateProjectViewControllerDelegate <NSObject>

- (void)popoverDidComplete;
- (void)loadProject;

@end