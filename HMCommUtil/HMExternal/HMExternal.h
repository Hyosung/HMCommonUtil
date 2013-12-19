//
//  HMExternal.h
//  NewUtil
//
//  Created by ismallstar on 13-12-9.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

/*
 外部框架或外部类
 */

#ifndef NewUtil_HMExternal_h
#define NewUtil_HMExternal_h

#if defined(__USE_ChineseToPinyin__) && __USE_ChineseToPinyin__
#import "ChineseToPinyin.h"
#endif

#if defined(__USE_ASIHttpRequest__) && __USE_ASIHttpRequest__
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
#endif

#if defined(__USE_PullingRefreshTableView__) && __USE_PullingRefreshTableView__
#import "PullingRefreshTableView.h"
#endif

#if defined(__USE_Reachability__) && __USE_Reachability__
#import "Reachability.h"
#endif

#if defined(__USE_SDWebImage__) && __USE_SDWebImage__
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#endif

#if defined(__USE_SVProgressHUD__) && __USE_SVProgressHUD__
#import "SVProgressHUD.h"
#endif

#if defined(__USE_SVWebViewController__) && __USE_SVWebViewController__
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#endif

#if defined(__USE_SoundManager__) && __USE_SoundManager__
#import "SoundManager.h"
#endif

#if defined(__USE_TTTAttributedLabel__) && __USE_TTTAttributedLabel__
#import "TTTAttributedLabel.h"
#endif

#if defined(__USE_iCarousel__) && __USE_iCarousel__
#import "iCarousel.h"
#endif

#endif
