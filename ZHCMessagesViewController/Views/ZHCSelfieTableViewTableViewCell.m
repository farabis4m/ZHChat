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
    [self customizeMediaView];
}

- (IBAction)editButtonAction:(id)sender {
    [self.delegate editButtonTapped:self];
}

-(void)customizeMediaView {
    CGRect rect = self.imageViewSelfie.frame;
    rect.size.height = self.frame.size.height - 10;
    rect.size.width = self.frame.size.height - 10;
    self.imageViewSelfie.frame = rect;
    self.imageViewSelfie.layer.cornerRadius = rect.size.width / 2;
    self.imageViewSelfie.layer.masksToBounds = YES;
    self.editButton.layer.cornerRadius = 5;
    self.editButton.hidden = NO;
    self.constraintImageViewMediaWidth.constant = rect.size.width;
    self.constraintImageViewMediaHeight.constant = rect.size.height;
    
}
@end
