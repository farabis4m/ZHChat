//
//  ZHCMessageDocumentTableViewCell.m
//  ZHChat
//
//  Created by Jafar Khan on 2/7/18.
//  Copyright © 2018 zhuo. All rights reserved.
//

#import "ZHCMessageDocumentTableViewCell.h"
#import "UIView+ZHCMessages.h"

@implementation ZHCMessageDocumentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButtonAction:(id)sender {
    [self.delegate editButtonTapped:self];
}

-(void)setMediaView:(UIView *)mediaView withisOutgoingMessage:(BOOL )isOutgoingMessage
{
    
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
    UIImageView *imageViewMedia = (UIImageView *)mediaView;
    imageViewMedia.contentMode = UIViewContentModeScaleAspectFit;
    [self updateConstraints];
    self.editButton.hidden = false;
    
}
@end
