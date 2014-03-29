//
//  NSData+AES256.h
//  NewHMUtil
//
//  Created by iyun on 13-12-8.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

/*
 AES256加密
 */
- (NSData *)AES256Encrypt:(NSString *) key;

/*
 AES256解密
 */
- (NSData *)AES256Decrypt:(NSString *) key;
@end
