//
//  HMUtil.m
//  HMUtil
//
//  Created by 曉星 on 13-5-21.
//  Copyright (c) 2013年 曉星. All rights reserved.
//

#import "HMUtil.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#if defined(__USE_HMCommon__) && __USE_HMCommon__
#import "HMCommon.h"
#endif

@interface HMUtil() {
#if defined(__USE_Reachability__) && __USE_Reachability__
    Reachability *hostReach;
    NetworkStatus curStatus;
#endif
}

#if defined(__USE_Reachability__) && __USE_Reachability__
- (void)reachabilityChanged:(NSNotification *)note;
#endif

+ (CGFloat)reckonWithSize:(CGSize) size
                 isHeight:(BOOL) flag
                   number:(CGFloat) number;
@end

@implementation HMUtil

#if defined(IMP_SINGLETON)
IMP_SINGLETON(HMUtil)
#endif

- (void)dealloc {
#if defined(__USE_Reachability__) && __USE_Reachability__
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [hostReach stopNotifier];
#endif
}

inline NSString * UUID() {
    
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDStr = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *uuidStr = (__bridge NSString *)(UUIDStr);
    CFRelease(UUID);
    CFRelease(UUIDStr);
    return uuidStr;
}

+ (UIImage *)imageNamed:(NSString *) name orType:(NSString *) ext {
    UIImage *image1x = nil;
    UIImage *image2x = nil;
    
    if (ext && ![ext isEqualToString:@""]) {
        image1x = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
        image2x = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:ext]];
    } else {
        image1x = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
        NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            name = [name stringByReplacingCharactersInRange:range withString:@"@2x."];
        } else {
            name = [NSString stringWithFormat:@"%@@2x",name];
        }
        image2x = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
    }
    
    if (isRetina && image2x) {
        return image2x;
    }
    
    return image1x;
}

+ (UIImage *)imageNamed:(NSString *) name {
    return [HMUtil imageNamed:name orType:@"png"];
}

+ (UIImage *)imageNamedExtJpg:(NSString *)name {
    return [HMUtil imageNamed:name orType:@"jpg"];
}

+ (UIImage *)imageCacheNamed:(NSString *)name {
    return [UIImage imageNamed:name];
}

+ (UIImage *)getImageFromView:(UIView *)orgView {
    UIGraphicsBeginImageContext(orgView.bounds.size);
    
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)savePhotosAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)saveImageFromToPhotosAlbum:(UIView*)view {
    UIImage *image = [HMUtil getImageFromView:view];
    [HMUtil savePhotosAlbum:image];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *) contextInfo {
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = @"成功保存到相册";
    } else {
        title = @"失败提示";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (NSString *)getTimeDiffString:(NSTimeInterval) timestamp {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *today = [NSDate date];//当前时间
    unsigned int unitFlag = NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *gap = [cal components:unitFlag fromDate:today toDate:todate options:0];//计算时间差
    
    if (ABS([gap day]) > 0)
    {
        return [NSString stringWithFormat:@"%ld天前", ABS((long)([gap day]))];
    }else if(ABS([gap hour]) > 0)
    {
        return [NSString stringWithFormat:@"%ld小时前", ABS((long)([gap hour]))];
    }else
    {
        return [NSString stringWithFormat:@"%ld分钟前",  ABS((long)([gap minute]))];
    }
}

+ (UIImage *)cutImageWithFrame:(CGRect)frame image:(UIImage *)image {
    
    CGFloat height = [HMUtil reckonWithSize:image.size width:CGRectGetWidth(frame)];
    if (image.size.width < CGRectGetWidth(frame)) {
        frame.size.width = image.size.width;
        if (image.size.height < CGRectGetHeight(frame)) {
            frame.size.height = image.size.height;
        }
    } else {
        UIImage *newImage1 = [HMUtil zoomImageWithSize:CGSizeMake(CGRectGetWidth(frame), height) image:image];
        if (newImage1.size.height < CGRectGetHeight(frame)) {
            frame.size.height = newImage1.size.height;
        }
    }
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    CGImageRelease(cutImageRef);
    return cutImage;
}

+ (UIImage *)zoomImageWithSize:(CGSize)size image:(UIImage *)image {
    UIImage *newImage = nil;
    UIGraphicsBeginImageContextWithOptions(size,YES,0);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    CGContextDrawImage(
                       UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, size.width, size.height),
                       [image CGImage]
                       );
    newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizedImageWithImage:(UIImage *)image
                          isHeight:(BOOL)flag
                            number:(CGFloat)number {
    CGSize size;
    if (flag) {
        size = CGSizeMake([HMUtil reckonWithSize:image.size height:number], number);
    }else{
        size = CGSizeMake(number, [HMUtil reckonWithSize:image.size width:number]);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizedImageWithImage:(UIImage *)image orHeight:(CGFloat)height {
    return [HMUtil resizedImageWithImage:image isHeight:YES number:height];
}

+ (UIImage *)resizedImageWithImage:(UIImage *)image orWidth:(CGFloat)width {
    return [HMUtil resizedImageWithImage:image isHeight:NO number:width];
}

+ (CGFloat)reckonWithSize:(CGSize) size
                 isHeight:(BOOL) flag
                   number:(CGFloat) number {
    CGFloat newNumber = 0.0f;
    CGFloat scale = size.height / size.width;
    if (!flag) {
        newNumber = scale * number;
    }else{
        newNumber = number / scale;
    }
    return newNumber;
}

+ (CGFloat)reckonWithSize:(CGSize) size height:(CGFloat) height {
    return [HMUtil reckonWithSize:size isHeight:YES number:height];
}

+ (CGFloat)reckonWithSize:(CGSize) size width:(CGFloat) width {
    return [HMUtil reckonWithSize:size isHeight:NO number:width];
}

+ (UIImage *)drawMask:(UIColor *)maskColor
      foregroundColor:(UIColor *)foregroundColor
      imageNamedOrExt:(NSString *)nameOrExt {
    return [HMUtil drawMask:maskColor
            foregroundColor:foregroundColor
                      image:[HMUtil imageNamed:nameOrExt orType:nil]];
}

+ (UIImage *)drawMask:(UIColor *)maskColor
      foregroundColor:(UIColor *)foregroundColor
                image:(UIImage *)originImage {
    CGRect imageRect = CGRectMake(
                                  0,
                                  0,
                                  CGImageGetWidth(originImage.CGImage),
                                  CGImageGetHeight(originImage.CGImage)
                                  );
    
    // 创建位图上下文
    
    CGContextRef context = CGBitmapContextCreate(NULL, // 内存图片数据
                                                 
                                                 imageRect.size.width, // 宽
                                                 
                                                 imageRect.size.height, // 高
                                                 
                                                 8, // 色深
                                                 
                                                 0, // 每行字节数
                                                 
                                                 CGImageGetColorSpace(originImage.CGImage), // 颜色空间
                                                 
                                                 CGImageGetBitmapInfo(originImage.CGImage)/*kCGImageAlphaPremultipliedLast*/);// alpha通道，RBGA
    
    // 设置当前上下文填充色为白色（RGBA值）
    CGContextSetRGBFillColor(
                             context,
                             CGColorGetComponents([foregroundColor CGColor])[0],
                             CGColorGetComponents([foregroundColor CGColor])[1],
                             CGColorGetComponents([foregroundColor CGColor])[2],
                             CGColorGetAlpha([foregroundColor CGColor])
                             );
    
    CGContextFillRect(context,imageRect);
    
    // 用 originImage 作为 clipping mask（选区）
    
    CGContextClipToMask(context,imageRect, originImage.CGImage);
    
    // 设置当前填充色为黑色
    CGContextSetRGBFillColor(
                             context,
                             CGColorGetComponents([maskColor CGColor])[0],
                             CGColorGetComponents([maskColor CGColor])[1],
                             CGColorGetComponents([maskColor CGColor])[2],
                             CGColorGetAlpha([maskColor CGColor])
                             );
    
    // 在clipping mask上填充黑色
    
    CGContextFillRect(context,imageRect);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage
                                            scale:originImage.scale
                                      orientation:originImage.imageOrientation];
    
    // Cleanup
    
    CGContextRelease(context);
    
    CGImageRelease(newCGImage);
    
    //    [UIImagePNGRepresentation(newImage) writeToFile:[XW_Document stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",nameOrExt]] atomically:YES];
    
    return newImage;
}

+ (UIImage *)drawPlaceholderWithSize:(CGSize)size {
    return [HMUtil drawPlaceholderWithSize:size bgcolor:PLACEHOLDER_COLOR];
}

+ (UIImage *)drawPlaceholderWithSize:(CGSize)size bgcolor:(UIColor *)color {
    UIImage *oldImage = [UIImage imageNamed:PLACEHOLDER_NAME];
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
    
    CGSize newSize;
    if (size.height > oldImage.size.height) {
        newSize = CGSizeMake(oldImage.size.height - 20, oldImage.size.height - 20);
    } else {
        newSize = CGSizeMake(size.height - 20, size.height - 20);
    }
    
    if (newSize.width >= size.width) {
        newSize = CGSizeMake(size.width - 20, size.width - 20);
    }
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    CGContextDrawImage(contextRef,CGRectMake(
                                             size.width / 2 - newSize.width / 2,
                                             size.height / 2 - newSize.height / 2,
                                             newSize.width,
                                             newSize.height
                                             ), [oldImage CGImage]);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)drawingColor:(UIColor *)color {
    return [HMUtil drawingColor:color size:CGSizeMake(57, 57)];
}

+ (UIImage *)drawingColor:(UIColor *)color size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContext(size);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
 **/
+ (UIImage *)drawGradientColor:(CGRect)p_clipRect
                       options:(CGGradientDrawingOptions)p_options
                        colors:(NSArray *)p_colors {
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(p_clipRect.size);
    CGContextRef p_context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(p_context);// 保持住现在的context
    CGContextClipToRect(p_context, p_clipRect);// 截取对应的context
    NSUInteger colorCount = p_colors.count;
    int numOfComponents = 4;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[colorCount * numOfComponents];
    for (int i = 0; i < colorCount; i++) {
        UIColor *color = p_colors[i];
        CGColorRef temcolorRef = color.CGColor;
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < numOfComponents; ++j) {
            colorComponents[i * numOfComponents + j] = components[j];
        }
    }
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
    CGColorSpaceRelease(rgb);
    CGPoint startPoint = p_clipRect.origin;
    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
    CGGradientRelease(gradient);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(p_context);// 恢复到之前的context
    UIGraphicsEndImageContext();
    
    //    [UIImagePNGRepresentation(newImage) writeToFile:[XW_Document stringByAppendingPathComponent:@"xw.png"] atomically:YES];
    return newImage;
}

+ (CGFloat)computeWidthWithString:(NSString *) aStr font:(UIFont *) font height:(CGFloat) height {
    
    CGFloat width = [aStr sizeWithFont:font
                     constrainedToSize:CGSizeMake(MAXFLOAT, height)
                         lineBreakMode:NSLineBreakByCharWrapping].height;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_AND_LATER) {
        width = CGRectGetHeight([aStr boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{ NSFontAttributeName: font }
                                                   context:nil]);
    }
#endif
    return width;
}

+ (CGFloat)computeHeightWithString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width {
    
    CGFloat height = [aStr sizeWithFont:font
                      constrainedToSize:CGSizeMake(width, MAXFLOAT)
                          lineBreakMode:NSLineBreakByCharWrapping].height;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_AND_LATER) {
        height = CGRectGetHeight([aStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{ NSFontAttributeName: font }
                                                    context:nil]);
    }
#endif
    return height;
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:emailRegex
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:nil];
    
    NSInteger numer = [regular numberOfMatchesInString:email
                                               options:NSMatchingAnchored
                                                 range:NSMakeRange(0, email.length)];
    
    return numer==1;
}

+ (BOOL)isOutNumber:(NSInteger)number
            objcect:(id)obj
             string:(NSString *)string
              range:(NSRange)range {
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"]) { //按会车可以改变
        return YES;
    }
    id textField=nil;
    if ([obj isKindOfClass:[UITextField class]]) {
        textField = obj;
    } else if ([obj isKindOfClass:[UITextView class]]) {
        textField = obj;
    } else {
        NSAssert(textField, @"obj instead of UITextField nor UITextView");
    }
    
    NSString * toBeString = [[textField text] stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    //  if (self.myTextField == textField)  //判断是否时我们想要限定的那个输入框
    //  {
    if ([toBeString length] > number) { //如果输入框内容大于number则弹出警告
        [textField setText:[toBeString substringToIndex:number]];
        return NO;
    }
    //  }
    return YES;
}

+ (NSString *)formattedFileSize:(unsigned long long)size {
    NSString *formattedStr = nil;
    if (size == 0) {
        formattedStr = @"Empty";
    } else {
        if (size > 0 && size < 1024) {
            formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
        } else {
            if (size >= 1024 && size < pow(1024, 2)) {
                formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
            } else {
                if (size >= pow(1024, 2) && size < pow(1024, 3)) {
                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                } else {
                    if (size >= pow(1024, 3)) {
                        formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
                    }
                }
            }
        }
    }
    return formattedStr;
}

+ (void)automaticCheckVersion:(void (^)(NSDictionary *))block url:(NSString *) url {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    NSString *URL = url;
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(
                                               NSURLResponse *response,
                                               NSData *data,
                                               NSError *error
                                               ) {
                               
                               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:nil];
                               NSArray *infoArray = dic[@"results"];
                               if ([infoArray count]) {
                                   NSDictionary *releaseInfo = infoArray[0];
                                   NSString *lastVersion = releaseInfo[@"version"];
                                   
                                   if (![lastVersion isEqualToString:currentVersion]) {
                                       NSString *trackViewURL = releaseInfo[@"trackViewUrl"];
                                       NSString *releaseNotes = releaseInfo[@"releaseNotes"];
                                       
                                       if (block) {
                                           
                                           block(@{
                                                   @"trackViewUrl": trackViewURL,
                                                   @"version": lastVersion,
                                                   @"releaseNotes": releaseNotes
                                                   });
                                       }
                                   }
                               }
                           }];
}

+ (void)onCheckVersion:(NSString *) url {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    NSString *URL = url;
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&error];
    
    if (recervedData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        NSArray *infoArray = dic[@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = infoArray[0];
            NSString *lastVersion = releaseInfo[@"version"];
            
            if (![lastVersion isEqualToString:currentVersion]) {
                NSString *trackViewURL = releaseInfo[@"trackViewUrl"];
                NSString *releaseNotes = releaseInfo[@"releaseNotes"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationAppUpdate"
                                                                    object:self
                                                                  userInfo:@{
                                                                             @"trackViewUrl": trackViewURL,
                                                                             @"version": lastVersion,
                                                                             @"releaseNotes": releaseNotes
                                                                             }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    __autoreleasing UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"软件更新"
                                                                                    message:@"当前版本已是最新版本"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
                    [alert show];
                });
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                __autoreleasing UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"软件更新"
                                                                                message:@"当前软件还未上线"
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                [alert show];
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __autoreleasing UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"软件更新"
                                                                            message:@"网络连接失败"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
            [alert show];
        });
    }
}

+ (void)applicationRatings:(NSString *) url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSString *)appStoreUrl:(NSString *) appid {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = info[@"CFBundleDisplayName"];
    //    NSString *displayName = [info objectForKey:@"CFBundleName"];
    //https://itunes.apple.com/us/app/bu-yi-li-ji/id647152789?mt=8&uo=4
    NSMutableArray *spliceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<displayName.length; i++) {
        NSString *spliceText = [NSString stringWithFormat:@"%C",[displayName characterAtIndex:i]];
        [spliceArray addObject:[ChineseToPinyin pinyinFromChiniseString:spliceText]];
    }
    
    NSString *appStoreURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@/id%@?mt=8",[spliceArray componentsJoinedByString:@"-"],appid];
    return [appStoreURL lowercaseString];
}

+ (void)setNavigationBar:(UINavigationBar *)navBar
         backgroundImage:(UIImage *)image {
    
    // Insert ImageView
    __autoreleasing UIImageView *_imgv = [[UIImageView alloc] initWithImage:image];
    _imgv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imgv.frame = navBar.bounds;
    UIView *v = [navBar subviews][0];
    v.layer.zPosition = -FLT_MAX;
    
    _imgv.layer.zPosition = -FLT_MAX + 1;
    [navBar insertSubview:_imgv atIndex:1];
}

+ (void)showNoContent:(BOOL) flag
          displayView:(UIView *) view
       displayContent:(NSString *) content {
    if (flag) {
        __block UILabel *label = nil;
        if (![view viewWithTag:1024]) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
            label.tag = 1024;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:17.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = view.center;
            
            [view addSubview:label];
        } else {
            label = (UILabel *)[view viewWithTag:1024];
        }
        label.alpha = 0;
        label.text = content;
        
        [UIView animateWithDuration:0.3 animations:^{
            label.alpha = 1;
        }];
    } else {
        if ([view viewWithTag:1024]) {
            UILabel *label = (UILabel *)[view viewWithTag:1024];
            [UIView animateWithDuration:0.3 animations:^{
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }
    }
}

//半角中空格的ascii码为32（其余ascii码为33-126），全角中空格的ascii码为12288（其余ascii码为65281-65374）
//半角与全角之差为65248
//半角转全角
+ (NSString *)DBCToSBC:(NSString *)dbc {
    NSString *sbc = @"";
    for (int i=0; i<dbc.length; i++) {
        unichar temp = [dbc characterAtIndex:i];
        if (temp >= 33 && temp <= 126) {
            temp = temp + 65248;
            sbc = [NSString stringWithFormat:@"%@%C",sbc,temp];
        }else{
            if (temp == 32) {
                temp = 12288;
            }
            sbc = [NSString stringWithFormat:@"%@%C",sbc,temp];
        }
    }
    return sbc;
}

//全角转半角
+ (NSString *)SBCToDBC:(NSString *)sbc {
    NSString *dbc = @"";
    
    for (int i=0; i<sbc.length; i++) {
        unichar temp = [sbc characterAtIndex:i];
        if (temp >= 65281 && temp <= 65374) {
            temp = temp - 65248;
            dbc = [NSString stringWithFormat:@"%@%C",dbc,temp];
        }else{
            if (temp == 12288) {
                temp = 32;
            }
            dbc = [NSString stringWithFormat:@"%@%C",dbc,temp];
        }
    }
    
    return dbc;
}

+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

+ (NSInteger)getRandomNumberTo:(NSInteger)to{
    return [HMUtil getRandomNumber:0 to:to];
}

+ (double)getFloatRandomNumber:(double)from to:(double)to {
    double randomNumber = from + ((double)arc4random() / ARC4RANDOM_MAX) * to;
    return [[NSString stringWithFormat:@"%0.1f",randomNumber] doubleValue];
}

#if defined(__USE_ASIHttpRequest__) && __USE_ASIHttpRequest__

+ (ASIFormDataRequest *)startAsynchronousRequestWithURLString:(NSString *)theUrl
                                                    parameter:(NSDictionary *)param
                                                      succeed:(void (^)(ASIFormDataRequest *))blockSucceed
                                                       failed:(void (^)(ASIFormDataRequest *, NSError *))blockFailed {
    
    NSURL *tempUrl = [NSURL URLWithString:theUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:tempUrl];
    if (param) {
        for (NSString *key in param.allKeys) {
            [request setPostValue:param[key] forKey:key];
        }
    }
    [request setCompletionBlock:^{
        if (blockSucceed) {
            blockSucceed(request);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = request.error;
        if (blockFailed) {
            blockFailed(request,error);
        }
    }];
    
    [request startAsynchronous];
    
    return request;
}
#endif

#if defined(__USE_Reachability__) && __USE_Reachability__
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (curStatus != status) {
        switch (status) {
            case ReachableViaWiFi:
            {
                [SVProgressHUD showNormalThenDismiss:@"当前网络WiFi"];
            }
                break;
            case ReachableViaWWAN:
            {
                [SVProgressHUD showNormalThenDismiss:@"当前网络3G/2G"];
            }
                break;
            case NotReachable:
            {
                [SVProgressHUD showAbnormalThenDismiss:@"当前网络不通畅"];
            }
                break;
            default:
                break;
        }
    }
    curStatus = status;
}

- (void)setNetworkNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    hostReach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [hostReach startNotifier];
}

+ (BOOL)isNotNetwork {
    return (![HMUtil isEnable3G] && ![HMUtil isEnableWiFi]);
}

// 是否wifi
+ (BOOL)isEnableWiFi {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
#endif

@end