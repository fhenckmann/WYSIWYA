//
//  ProjectResourcesDetailViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 13/08/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectResourcesDetailViewController : UITableViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *fistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;

@end
