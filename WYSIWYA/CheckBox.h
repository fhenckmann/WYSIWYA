//
//  CheckBox.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBox : UIButton

@property (nonatomic, assign) BOOL isChecked;

- (IBAction) checkBoxClicked;

@end
