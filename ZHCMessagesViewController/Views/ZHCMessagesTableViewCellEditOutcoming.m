//
//  ZHCMessagesTableViewCellEditOutcoming.m
//  ZHChat
//
//  Created by Marwan Ayman on 12/17/17.
//  Copyright © 2017 zhuo. All rights reserved.
//

#import "ZHCMessagesTableViewCellEditOutcoming.h"
#import "UIView+ZHCMessages.h"

@implementation ZHCMessagesTableViewCellEditOutcoming

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setShowEditButton:(BOOL)showEditButton {
    if (self.showEditButton){
        self.constraintTextViewTrailing.constant = 5;
        self.constraintMessageBubbleLeading.constant = 0;
        self.editButton.hidden = NO;
    }
    else {
        self.constraintTextViewTrailing.constant = -45;
        self.editButton.hidden = YES;
        self.constraintMessageBubbleLeading.constant = 45;
    }
    [self layoutIfNeeded];
    [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMediaView:(UIView *)mediaView withisOutgoingMessage:(BOOL )isOutgoingMessage
{
    
    [self.textView removeFromSuperview];
    CGRect f = mediaView.frame;
    f.size.height = self.messageBubbleImageView.frame.size.height - 65;
    f.size.width = self.messageBubbleImageView.frame.size.width - 150;
    mediaView.frame = f;
    [self.messageBubbleContainerView addSubview:mediaView];
    mediaView.clipsToBounds = YES;
    [self.messageBubbleContainerView zhc_pinSubview:mediaView toEdge:NSLayoutAttributeBottom withConstant:-2.0f];
    
    //[mediaView zhc_pinSelfToEdge:NSLayoutAttributeHeight withConstant:CGRectGetHeight(self.messageBubbleImageView.frame)];
    //[mediaView zhc_pinSelfToEdge:NSLayoutAttributeWidth withConstant:CGRectGetWidth(self.messageBubbleImageView.frame)];
    
    if (isOutgoingMessage) {
        [self.messageBubbleContainerView zhc_pinSubview:mediaView toEdge:NSLayoutAttributeTrailing withConstant:-50.0f];
    }else{
        [self.messageBubbleContainerView zhc_pinSubview:mediaView toEdge:NSLayoutAttributeLeading withConstant:2.0f];
    }
    self.mediaView = mediaView;
    
    [self updateConstraints];
    
}

@end
