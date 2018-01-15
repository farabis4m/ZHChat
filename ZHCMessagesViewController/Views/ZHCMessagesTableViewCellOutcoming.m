//
//  ZHCMessagesTableViewCellIncoming.m
//  ZHChat
//
//  Created by aimoke on 16/8/9.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesTableViewCellOutcoming.h"
#import "ZHCMessagesTableviewLayoutAttributes.h"
@implementation ZHCMessagesTableViewCellOutcoming


#pragma mark - Initialzition
- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentRight;
    self.cellBottomLabel.textAlignment = NSTextAlignmentRight;
    self.textView.backgroundColor = [UIColor grayColor];
    [self setShowEditButton:self.showEditButton];
  }

-(void)setShowEditButton:(BOOL)showEditButton{
    if (showEditButton){
        self.textViewAlignmentConstraint.constant = 42.0;
        self.messageBubbleLeadingConstraint.constant = 0;
        self.editButton.hidden = NO;
    }
    else {
        self.textViewAlignmentConstraint.constant = 0;
        self.editButton.hidden = YES;
        self.messageBubbleLeadingConstraint.constant = 42.0;
    }
    [self layoutIfNeeded];
    [self layoutSubviews];
}

- (IBAction)editButtonAction:(id)sender {
    [self.delegate editButtonTapped:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
