//
//  ZHCPhotoBubbleMediaItem.m
//  ZHChat
//
//  Created by Marwan Ayman on 12/18/17.
//  Copyright © 2017 zhuo. All rights reserved.
//

#import "ZHCPhotoBubbleMediaItem.h"
@interface ZHCPhotoBubbleMediaItem()
@property (strong, nonatomic) UIImageView *cachedImageView;
@end

@implementation ZHCPhotoBubbleMediaItem

- (UIView *)mediaView
{
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        imageView.frame = CGRectMake(10.0f, 10.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.cachedImageView = imageView;
    }
    
    return self.cachedImageView;
}

@end
