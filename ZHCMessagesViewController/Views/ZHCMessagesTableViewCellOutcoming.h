//
//  ZHCMessagesTableViewCellIncoming.h
//  ZHChat
//
//  Created by aimoke on 16/8/9.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesTableViewCell.h"
#import <UIKit/UIKit.h>

@interface ZHCMessagesTableViewCellOutcoming : ZHCMessagesTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewAlignmentConstraint;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end
