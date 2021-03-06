//
//  HMUtil.h
//  HMUtil
//
//  Created by 曉星 on 13-4-2.
//  Copyright (c) 2013年 曉星. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 常用工具类
 */

#define PLACEHOLDER_NAME @"placeholder"
#define PLACEHOLDER_COLOR COLORRGB(228, 228, 228)
/*
 用于生成浮点型的随机数
 */
#define ARC4RANDOM_MAX 0x100000000

@interface HMUtil : NSObject

#if defined(HM_SINGLETON)
HM_SINGLETON(HMUtil)
#endif

extern inline NSString * UUID();

#if defined(__USE_Reachability__) && __USE_Reachability__
- (void)setNetworkNotification;

/*
 是否有打开网络
 */
+ (BOOL)isNotNetwork;

/*
 是否启动WiFi
 */
+ (BOOL)isEnableWiFi;

/*
 是否启动3G
 */
+ (BOOL)isEnable3G;
#endif

/*
 无缓存取图
 */
+ (UIImage *)imageNamed:(NSString *) name
                 orType:(NSString *) ext;
+ (UIImage *)imageNamed:(NSString *) name;
+ (UIImage *)imageNamedExtJpg:(NSString *) name;

/*
 有缓存取图
 */
+ (UIImage *)imageCacheNamed:(NSString *) name;

/*
 截取当前View上的内容，并返回图片
 */
+ (UIImage *)getImageFromView:(UIView *) orgView;

/*
 将多张图片合成一张
 @images 例:@[ @{ @"image": image1,@"rect": @"{{0,0},{120,120}}" },@{ @"image": image2,@"rect": @"{{120,0},{120,120}}" }]
 @size 合成图片的大小
 @return 合成的图片
 */
+ (UIImage *)imageSynthesisWithImages:(NSArray *) images andSize:(CGSize) size;

/*
 保存图片到相册
 */
+ (void)savePhotosAlbum:(UIImage *)image;

/*
 保存当前view截图到相册
 */
+ (void)saveImageFromToPhotosAlbum:(UIView*)view;

+ (NSString *)getTimeDiffString:(NSTimeInterval) timestamp;

/*
 从传入图片上截取指定区域的图片
 */
+ (UIImage *)cutImageWithFrame:(CGRect) frame image:(UIImage *) image;

/*
 缩放传入图片到指定大小
 */
+ (UIImage *)zoomImageWithSize:(CGSize) size image:(UIImage *) image;

/*
 重置图片的大小，图片不变形，只压缩
 @number 高度或者宽度
 @flag 传入的number值是高度或者宽度 YES:高度，NO:宽度
 */
+ (UIImage *)resizedImageWithImage:(UIImage *)image
                          isHeight:(BOOL)flag
                            number:(CGFloat)number;

/*
 重置图片的大小，图片不变形，只压缩
 @size 图片大小
 */
+ (UIImage *)resizedImageWithImage:(UIImage *)image
                              size:(CGSize)size;
/*
 知道高度，重置图片大小
 */
+ (UIImage *)resizedImageWithImage:(UIImage *)image
                            orHeight:(CGFloat)height;
/*
 知道宽度，重置图片大小
 */
+ (UIImage *)resizedImageWithImage:(UIImage *)image
                            orWidth:(CGFloat)width;

/*
 根据高度计算对应的宽度
 */
+ (CGFloat)reckonWithSize:(CGSize) size
                   height:(CGFloat) height;
/*
 根据宽度计算对应的高度
 */
+ (CGFloat)reckonWithSize:(CGSize) size
                    width:(CGFloat) width;

/*
 给纯色图片重绘颜色  注:只对纯色图片有效
 @maskColor 罩遮色
 @foregroundColor 前景色
 @nameOrExt 图片名称包括后缀
 */
+ (UIImage *)drawMask:(UIColor *) maskColor
      foregroundColor:(UIColor *) foregroundColor
      imageNamedOrExt:(NSString *) nameOrExt;

/*
 给纯色图片重绘颜色  注:只对纯色图片有效
 @maskColor 罩遮色
 @foregroundColor 前景色
 @image 图片对象
 */
+ (UIImage *)drawMask:(UIColor *) maskColor
      foregroundColor:(UIColor *) foregroundColor
      image:(UIImage *) image;

/*
 根据传入的size绘制占位图 默认背景色 RGBCOLOR(228, 228, 228)
 */
+ (UIImage *)drawPlaceholderWithSize:(CGSize) size;

/*
 根据传入的size绘制占位图
 @color 背景色
 */
+ (UIImage *)drawPlaceholderWithSize:(CGSize) size
                             bgcolor:(UIColor *) color;

/*
 根据传入的颜色绘制纯色图片 默认大小 {57，57}
 */
+ (UIImage *)drawingColor:(UIColor *) color;

/*
 绘制纯色图片
 @color 要绘制的颜色
 @size 图片大小
 */
+ (UIImage *)drawingColor:(UIColor *) color
                     size:(CGSize) size;

/*
 绘制渐变图
 */
+ (UIImage *)drawGradientColor:(CGRect)p_clipRect
                  options:(CGGradientDrawingOptions)p_options
                   colors:(NSArray *)p_colors;

/*
 计算文本size 只针对单行
 @aStr 文本内容
 @font 字体
 */
+ (CGSize)computeSizeWithString:(NSString *) aStr font:(UIFont *) font;

/*
 计算文本宽度 只针对多行
 @aStr 文本内容
 @font 字体
 @height 默认高度
 */
+ (CGFloat)computeWidthWithString:(NSString *) aStr font:(UIFont *) font height:(CGFloat) height;

/*
 计算文本的高度 只针对多行
 @aStr 文本内容
 @font 字体
 @width 默认宽度
 */
+ (CGFloat)computeHeightWithString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width;

/*
 验证邮箱格式
 */
+ (BOOL)isValidateEmail:(NSString *) email;

/*
限制UITextView或者UITextField的输入字数
 @number 能输入的字数
 @obj UITextView对象或者UITextField对象
 @string 当前对象中的字符串
 @range 当前对象的范围大小
 */
+ (BOOL)isOutNumber:(NSInteger) number
            objcect:(id) obj
             string:(NSString *)string
              range:(NSRange) range;

/*
 格式化文件大小
 @size 文件大小 字节（bytes）
 */
+ (NSString *)formattedFileSize:(unsigned long long)size;

/*
 自动检查版本是否可更新，并提示
 @url 在Apple Store 上请求的链接
 @block-releaseInfo 字典中包含了应用在Apple Store上的下载地址和更新的信息、最新版本号，对应的key是trackViewUrl、releaseNotes、version
 */
+ (void)automaticCheckVersion:(void(^)(NSDictionary *releaseInfo)) block
                          url:(NSString *) url;

/*
 检查是否有最新版本
 有最新版本就从消息中心发出消息 消息名称是 NotificationAppUpdate
 */
+ (void)onCheckVersion:(NSString *) url;

/*
 跳转到App Store应用的评分页面
 @url 默认 SCORE_URL
 */
+ (void)applicationRatings:(NSString *) url;

/*
 应用在 App Store的下载地址
 @appid 应用的Apple ID
 */
+ (NSString *)appStoreUrl:(NSString *) appid;

/*
 设置导航栏的背景 支持大部分iOS版本
 */
+ (void)setNavigationBar:(UINavigationBar *) navBar
         backgroundImage:(UIImage *) image;

/*
 给导航栏添加一个view覆盖在上面
 */
+ (void)setNavigationBar:(UINavigationBar *)navBar
             contentView:(UIView *)view;

/*
 当请求返回无数据时显示
 @flag 是否显示
 @view 显示提示的view
 @content 提示内容
 */
+ (void)showNoContent:(BOOL) flag
          displayView:(UIView *) view
       displayContent:(NSString *) content;

/*
 半角转全角
 @dbc 半角字符串
 */
+ (NSString *)DBCToSBC:(NSString *) dbc;

/*
 全角转半角
 @sbc 全角字符串
 */
+ (NSString *)SBCToDBC:(NSString *) sbc;

/*
 生成from到to之间的随机数
 范围是[from,to) 包含from,不包含to
 */
+ (NSInteger)getRandomNumber:(NSInteger) from to:(NSInteger) to;

/*
 生成0-to之间的随机数
 范围是[0,to) 包含0,不包含to
 */
+ (NSInteger)getRandomNumberTo:(NSInteger) to;

/*
 生成浮点型的随机数
 范围[from,to) 包含from,不包含to
 默认随机数一位小数点
 */
+ (double)getFloatRandomNumber:(double) from to:(double) to;

#if defined(__USE_ASIHttpRequest__) && __USE_ASIHttpRequest__
/*
 开启一个异步POST请求
 */
+ (ASIFormDataRequest *)startAsynchronousRequestWithURLString:(NSString *) theUrl
                                                    parameter:(NSDictionary *) param
                                                      succeed:(void (^)(ASIFormDataRequest *request)) blockSucceed
                                                       failed:(void (^)(ASIFormDataRequest *request, NSError *error)) blockFailed;

/*
 创建一个异步POST请求
 */
+ (ASIFormDataRequest *)createAsynchronousRequestWithURLString:(NSString *) theUrl
                                                     parameter:(NSDictionary *) param;

/*
 开启一个异步队列
 */
+ (ASINetworkQueue *)startNetworkQueueWithRequests:(NSArray *) requests
                                    requestSucceed:(void (^)(ASIHTTPRequest *request)) requestBlockSucceed
                                     requestFailed:(void (^)(ASIHTTPRequest *request, NSError *error)) requestBlockFailed
                                      queueSucceed:(void (^)(ASINetworkQueue *queue)) queueBlock;
#endif

#if defined(__USE_QuartzCore__) && __USE_QuartzCore__
/**********************************************常用动画************************************************/
#pragma mark - Custom Animation

/**
 *   @brief 快速构建一个你自定义的动画,有以下参数供你设置.
 *
 *   @note  调用系统预置Type需要在调用类引入下句
 *
 *          #import <QuartzCore/QuartzCore.h>
 *
 *   @param type                动画过渡类型
 *   @param subType             动画过渡方向(子类型)
 *   @param duration            动画持续时间
 *   @param timingFunction      动画定时函数属性
 *   @param theView             需要添加动画的view.
 *
 *
 */

+ (void)showAnimationType:(NSString *)type
              withSubType:(NSString *)subType
                 duration:(CFTimeInterval)duration
           timingFunction:(NSString *)timingFunction
                     view:(UIView *)theView;

#pragma mark - Preset Animation

/**
 *  下面是一些常用的动画效果
 */

// reveal
+ (void)animationRevealFromBottom:(UIView *)view;
+ (void)animationRevealFromTop:(UIView *)view;
+ (void)animationRevealFromLeft:(UIView *)view;
+ (void)animationRevealFromRight:(UIView *)view;

// 渐隐渐消
+ (void)animationEaseIn:(UIView *)view;
+ (void)animationEaseOut:(UIView *)view;

// 翻转
+ (void)animationFlipFromLeft:(UIView *)view;
+ (void)animationFlipFromRigh:(UIView *)view;

// 翻页
+ (void)animationCurlUp:(UIView *)view;
+ (void)animationCurlDown:(UIView *)view;

// push
+ (void)animationPushUp:(UIView *)view;
+ (void)animationPushDown:(UIView *)view;
+ (void)animationPushLeft:(UIView *)view;
+ (void)animationPushRight:(UIView *)view;

// move
+ (void)animationMoveUp:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveDown:(UIView *)view duration:(CFTimeInterval)duration;
+ (void)animationMoveLeft:(UIView *)view;
+ (void)animationMoveRight:(UIView *)view;

// 旋转缩放

// 各种旋转缩放效果
+ (void)animationRotateAndScaleEffects:(UIView *)view;

// 旋转同时缩小放大效果
+ (void)animationRotateAndScaleDownUp:(UIView *)view;



#pragma mark - Private API

/**
 *  下面动画里用到的某些属性在当前API里是不合法的,但是也可以用.
 */

+ (void)animationFlipFromTop:(UIView *)view;
+ (void)animationFlipFromBottom:(UIView *)view;

+ (void)animationCubeFromLeft:(UIView *)view;
+ (void)animationCubeFromRight:(UIView *)view;
+ (void)animationCubeFromTop:(UIView *)view;
+ (void)animationCubeFromBottom:(UIView *)view;

+ (void)animationSuckEffect:(UIView *)view;

+ (void)animationRippleEffect:(UIView *)view;

+ (void)animationCameraOpen:(UIView *)view;
+ (void)animationCameraClose:(UIView *)view;
#endif
@end
