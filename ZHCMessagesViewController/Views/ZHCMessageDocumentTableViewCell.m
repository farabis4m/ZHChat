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

-(void)setMediaView:(UIView *)mediaView withisOutgoingMessage:(BOOL )isOutgoingMessage{
    self.mediaView = mediaView;
    self.imageViewDocument.image = [(UIImageView *)self.mediaView image];
    [self updateConstraints];
    self.editButton.hidden = false;
}

@end
