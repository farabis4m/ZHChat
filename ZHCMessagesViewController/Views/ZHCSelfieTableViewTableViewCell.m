//
//  ZHCSelfieTableViewTableViewCell.m
//  ZHChat
//
//  Created by Jafar Khan on 2/7/18.
//  Copyright © 2018 zhuo. All rights reserved.
//

#import "ZHCSelfieTableViewTableViewCell.h"

@implementation ZHCSelfieTableViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMediaView:(UIView *)mediaView withisOutgoingMessage:(BOOL)isOutgoingMessage {
    self.mediaView = mediaView;
    if ([mediaView isKindOfClass:[UIImageView class]]) {
        self.imageViewSelfie.image = [(UIImageView *)mediaView image];
    }
}

@end
