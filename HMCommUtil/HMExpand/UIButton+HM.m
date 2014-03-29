//
//  UIButton+HM.m
//  HMCommUtil
//
//  Created by ismallstar on 13-12-18.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import "UIButton+HM.h"

@implementation UIButton (HM)

#if defined(__USE_SDWebImage__) && __USE_SDWebImage__
- (void)setHmImageURLString:(NSString *)anURLString {
    [self setHmImageURLString:anURLString forState:UIControlStateNormal];
}

- (void)setHmImageURLString:(NSString *)anURLString forState:(UIControlState)state {
    NSURL *URL = [NSURL URLWithString:anURLString];
    UIImage *placeholderImage = [HMUtil drawPlaceholderWithSize:self.frame.size];
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:URL forState:state placeholderImage:placeholderImage
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                    if (image && !error) {
                        UIImage *newImage = [HMUtil zoomImageWithSize:weakSelf.frame.size image:image];
                        [weakSelf setImage:newImage forState:state];
                    }
                }];
}

- (void)setHmBackgroundImageURLString:(NSString *) anURLString {
    [self setHmBackgroundImageURLString:anURLString forState:UIControlStateNormal];
}

- (void)setHmBackgroundImageURLString:(NSString *) anURLString forState:(UIControlState)state {
    NSURL *URL = [NSURL URLWithString:anURLString];
    UIImage *placeholderImage = [HMUtil drawPlaceholderWithSize:self.frame.size];
    
    __weak typeof(self) weakSelf = self;
    [self setBackgroundImageWithURL:URL forState:state placeholderImage:placeholderImage
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                    if (image && !error) {
                        UIImage *newImage = [HMUtil zoomImageWithSize:weakSelf.frame.size image:image];
                        [weakSelf setBackgroundImage:newImage forState:state];
                    }
                }];
}
#endif

@end
