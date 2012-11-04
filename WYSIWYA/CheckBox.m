//
//  CheckBox.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox


- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        // Initialization code
           
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self setImage:[UIImage imageNamed:@"checkbox_unticked.jpg"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
        self.isChecked = NO;
        
    }
    
    return self;
    
}



-(IBAction) checkBoxClicked
{
    
    if (self.isChecked == NO) {
        
        self.isChecked = YES;
        [self setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
            
    } else {
        
        self.isChecked = NO;
        
        [self setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        
    }

}


@end
