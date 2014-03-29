//
//  UIButton+HM.h
//  HMCommUtil
//
//  Created by ismallstar on 13-12-18.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HM)

#if defined(__USE_SDWebImage__) && __USE_SDWebImage__
- (void)setHmImageURLString:(NSString *) anURLString;
- (void)setHmImageURLString:(NSString *) anURLString forState:(UIControlState)state;

- (void)setHmBackgroundImageURLString:(NSString *) anURLString;
- (void)setHmBackgroundImageURLString:(NSString *) anURLString forState:(UIControlState)state;
#endif
@end
