//
//  LoadProgressViewController.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/10/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadProgressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
- (IBAction)cancelLoad:(id)sender;

@end
