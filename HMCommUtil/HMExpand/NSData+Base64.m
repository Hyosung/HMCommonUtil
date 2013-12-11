//
//  NSData+Base64.m
//  NewHMUtil
//
//  Created by iyun on 13-12-8.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

#import "NSData+Base64.h"

#import "GTMBase64.h"

@implementation NSData (Base64)

- (NSString*)encodeBase64 {
    NSData *data = [GTMBase64 encodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (NSString*)decodeBase64 {
    NSData *data = [GTMBase64 decodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

@end
