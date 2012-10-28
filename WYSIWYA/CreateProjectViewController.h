//
//  CreateProjectViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 11/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataController;

@protocol CreateProjectViewControllerDelegate;

@interface CreateProjectViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) id <CreateProjectViewControllerDelegate> delegate;
@property (strong,nonatomic) CoreDataController* dataController;
@property (weak, nonatomic) IBOutlet UITextField *inputProjectName;
@property (weak, nonatomic) IBOutlet UITextField *inputProjectDescription;
@property (weak, nonatomic) IBOutlet UITextField *inputStartDate;
@property (weak, nonatomic) IBOutlet UITextField *inputEndDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateChanged:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol CreateProjectViewControllerDelegate <NSObject>

- (void)popoverDidComplete;

@end