//
//  IndentedUILabel.m
//  WYSIWYA
//
//  Created by Fabian Henckmann on 3/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import "IndentedUILabel.h"

@implementation IndentedUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect

{
    
    UIEdgeInsets insets = {0, self.indention, 0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
    
}

@end
