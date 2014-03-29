//
//  UIImageView+HM.h
//  HMCommUtil
//
//  Created by ismallstar on 13-12-18.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HM)

#if defined(__USE_SDWebImage__) && __USE_SDWebImage__
- (void)setHmImageURLString:(NSString *) anURLString;
#endif

@end
