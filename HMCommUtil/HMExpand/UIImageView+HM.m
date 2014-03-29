//
//  UIImageView+HM.m
//  HMCommUtil
//
//  Created by ismallstar on 13-12-18.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import "UIImageView+HM.h"

@implementation UIImageView (HM)

#if defined(__USE_SDWebImage__) && __USE_SDWebImage__
- (void)setHmImageURLString:(NSString *)anURLString {
    NSURL *URL = [NSURL URLWithString:anURLString];
    UIImage *placeholderImage = [HMUtil drawPlaceholderWithSize:self.frame.size];
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:URL placeholderImage:placeholderImage
                completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType) {
        if (image && !error) {
            
            UIImage *newImage = [HMUtil zoomImageWithSize:weakSelf.frame.size image:image];
            weakSelf.image = newImage;
        }
    }];
}
#endif

@end
