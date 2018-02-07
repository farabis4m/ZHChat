//
//  ZHCMessageSelfieTableViewCell.h
//  ZHChat
//
//  Created by Jafar Khan on 2/7/18.
//  Copyright © 2018 zhuo. All rights reserved.
//

#import "ZHCMessagesTableViewCellOutcoming.h"

@interface ZHCMessageSelfieTableViewCell : ZHCMessagesTableViewCellOutcoming
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelfie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageViewMediaWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageViewMediaHeight;

@end
