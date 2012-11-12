//
//  TaskCellView.h
//  WYSIWYA
//
//  Created by Fabian Henckmann on 11/11/12.
//  Copyright (c) 2012 Fabian Henckmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndentedUILabel;

@interface TaskCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *wbsLabel;
@property (weak, nonatomic) IBOutlet IndentedUILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pctCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *effortLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignedToLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftBorder;
@property (weak, nonatomic) IBOutlet UIImageView *midSection;
@property (weak, nonatomic) IBOutlet UIImageView *rightBorder;

@end
