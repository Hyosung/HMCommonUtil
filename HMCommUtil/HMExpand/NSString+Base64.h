//
//  NSString+Base64.h
//  NewHMUtil
//
//  Created by iyun on 13-12-8.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/*
 Base64加密
 */
- (NSString*)encodeBase64;

/*
 Base64解密
 */
- (NSString*)decodeBase64;
@end
