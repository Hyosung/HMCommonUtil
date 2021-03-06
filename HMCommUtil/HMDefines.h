//
//  HMDefines.h
//  NewNSUtil
//
//  Created by ismallstar on 13-12-9.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

/*
 定义常用的宏定义或常量
 */

#ifndef NewNSUtil_HMDefines_h
#define NewNSUtil_HMDefines_h

static NSString * const HMAppleID = @"Apple ID";
static NSString * const HMCompanyName = @"Company Name";

/*
 round(<#double#>)：如果参数是小数，则求本身的四舍五入。
 ceil(<#double#>)：如果参数是小数，则求最小的整数但不小于本身.
 floor(<#double#>)：如果参数是小数，则求最大的整数但不大于本身.
 */

/*
 #undef 标识符 用意：取消前面定义的宏定义
 如果标识符当前没有被定义成一个宏名称，那么就会忽略该指令
 
 #ifndef 标识符
 预编译块
 #endif
 用意：相当于 if not defined 的简写，表示标识符如果没被定义过就进入预编译块
 
 #if defined 标识符
 预编译块
 #endif
 用意：判断标识符是否已被定义定义过就进入预编译块
 
 #ifdef 标识符
 // 预编译块
 #endif
 用意：如果定义了标识符就进入预编译块
 
 #if 表达式
 // 程序段1
 #else
 // 程序段2
 #endif
 用意：当指定的表达式值为真（非零）时就编译程序段1，否则编译程序段2。可以事先给定一定条件，使程序在不同的条件下执行不同的功能。
 
 typedef 用意： 为现有类型创建一个新的名字，或称为类型别名
 用法：
 typedef 类型名 新类型名
 
 #define 标识符 用意：定义宏
 #define 并不是定义变量
 #define 只是用来做文本替换的
 # 表示将标识符转为C字符串
 ## 连接符号 用于连接前后两个参数
 @# 字符化操作符 用于将参数转为OC字符串
 
 #pragma 参数 最复杂的预处理指令
 常用参数
 #pragma message("消息文本")  当编译器遇到这条指令时就在编译输出窗口中将消息文本打印出来
 #pragma code_seg( ["section-name"[,"section-class"] ] ) 它能够设置程序中函数代码存放的代码段，当我们开发驱动程序的时候就会使用到它
 #pragma once
 (比较常用）
 只要在头文件的最开始加入这条指令就能够保证头文件被编译一次，这条指令实际上在VC6中就已经有了，但是考虑到兼容性并没有太多的使用它。
 #pragma hdrstop 表示预编译头文件到此为止，后面的头文件不进行预编译
 #pragma resource "*.dfm" 表示把*.dfm文件中的资源加入工程
 #pragma warning
 
 #pragma warning( disable : 4507 34; once : 4385; error : 164 )
 等价于：
 #pragma warning(disable:4507 34) // 不显示4507和34号警告信息
 #pragma warning(once:4385) // 4385号警告信息仅报告一次
 #pragma warning(error:164) // 把164号警告信息作为一个错误。
 
 同时这个pragma warning 也支持如下格式：
 #pragma warning( push [ ,n ] )
 #pragma warning( pop )
 
 这里n代表一个警告等级(1---4)。
 #pragma warning( push )保存所有警告信息的现有的警告状态。
 #pragma warning( push, n)保存所有警告信息的现有的警告状态，并且把全局警告等级设定为n。
 #pragma warning( pop )向栈中弹出最后一个警告信息，
 
 在入栈和出栈之间所作的一切改动取消。例如：
 #pragma warning( push )
 #pragma warning( disable : 4705 )
 #pragma warning( disable : 4706 )
 #pragma warning( disable : 4707 )
 //.......
 #pragma warning( pop )
 在这段代码的最后，重新保存所有的警告信息(包括4705，4706和4707)。
 
 #pragma comment( comment-type ,["commentstring"] )
 comment-type是一个预定义的标识符，指定注释的类型，应该是compiler，exestr，lib，linker之一。
 commentstring是一个提供为comment-type提供附加信息的字符串。
 注释类型：
 1、compiler：
 放置编译器的版本或者名字到一个对象文件，该选项是被linker忽略的。
 2、exestr：
 在以后的版本将被取消。
 3、lib：
 放置一个库搜索记录到对象文件中，这个类型应该是和commentstring（指定你要Linker搜索的lib的名称和路径）这个库的名字放在Object文件的默认库搜索记录的后面，linker搜索这个这个库就像你在命令行输入这个命令一样。你可以在一个源文件中设置多个库记录，它们在object文件中的顺序和在源文件中的顺序一样。如果默认库和附加库的次序是需要区别的，使用Z编译开关是防止默认库放到object模块。
 4、linker：
 指定一个连接选项，这样就不用在命令行输入或者在开发环境中设置了。
 只有下面的linker选项能被传给Linker.
 /DEFAULTLIB ,/EXPORT,/INCLUDE,/MANIFESTDEPENDENCY, /MERGE,/SECTION
 
 #pragma disable
 　　在函数前声明，只对一个函数有效。该函数调用过程中将不可被中断。一般在C51中使用较多。
 
 #pragma data_seg
 介绍[1]
 用#pragma data_seg建立一个新的数据段并定义共享数据，其具体格式为：
 #pragma data_seg （"shareddata")
 HWND sharedwnd=NULL;//共享数据
 #pragma data_seg()
 -----------------------------------------------------------------
 1，#pragma data_seg()一般用于DLL中。也就是说，在DLL中定义一个共享的有名字的数据段。最关键的是：这个数据段中的全局变量可以被多个进程共享,否则多个进程之间无法共享DLL中的全局变量。
 2，共享数据必须初始化，否则微软编译器会把没有初始化的数据放到.BSS段中，从而导致多个进程之间的共享行为失败.
 
 __LINE__ 当前行数  #line指令可以改变它的值
 __FILE__ 当前文件名
 __DATE__ 宏指令含有形式为月/日/年的串,表示源文件被翻译到代码时的日期。
 __TIME__ 宏指令包含程序编译的时间。时间用字符串表示，其形式为： 分：秒
 __func__ GCC编译器 C99标准里面预定义标识符 输出函数的名称
 __FUNCTION__ GCC编译器 输出函数的名称
 __PRETTY_FUNCTION__ GCC编译器 输出函数的名称和参数
 
 extern "C"
 (1)在C++中引用C语言中的函数和变量 (C语言中不支持extern
 "C"声明，在.c文件中包含了extern "C"时会出现编译语法错误)
 例：extern "C"{#include <string.h>}
 
 (2)在C中引用C++语言中的函数和变量时，C++的头文件需添加extern
 "C"，但是在C语言中不能直接引用声明了extern
 "C"的该头文件，应该仅将C文件中将C++中定义的extern "C"函数声明为extern类型
 例：//C++头文件 cppExample.h
 #ifndef CPP_EXAMPLE_H
 #define CPP_EXAMPLE_H
 extern "C" int add( int x, int y );
 #endif
 //C++实现文件 cppExample.cpp
 #include "cppExample.h"
 int add( int x, int y )
 {
 return x + y;
 }
 C实现文件 cFile.c
 这样会编译出错：#include "cExample.h"
 extern int add( int x, int y );
 int main( int argc, char* argv[] )
 {
 add( 2, 3 );
 return 0;
 }
 */

/*
 单例的方法申明
 */
#undef HM_SINGLETON
#define HM_SINGLETON(__class) \
+ (__class *)shared##__class;

/*
 单例的实现方法
 */
#undef IMP_SINGLETON
#define IMP_SINGLETON(__class) \
+ (__class *)shared##__class{\
static dispatch_once_t onceToken;\
static __class *__singleton__ = nil;\
dispatch_once(&onceToken, ^{\
__singleton__ = [[__class alloc] init];\
});\
return __singleton__;\
}

/*
 只执行一次（这里是开始）
 */
#undef BEGIN_SINGLETON
#define BEGIN_SINGLETON \
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\

/*
 只执行一次（这里是结束）
 */
#undef END_SINGLETON
#define END_SINGLETON });

/*
 用于在浏览器中跳转到App Store应用中去的链接 并跳转到评分页面
 */
#define SCORE_URL [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",HMAppleID]

/*
 用于在Apple Store上请求当前Apple ID 的相关信息的链接
 */
#define APP_URL [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",HMAppleID]

#define IMAGE_REQUEST(TEXT) [NSString stringWithFormat:@"http://image.zontenapp.com.cn/%@/%@",HMCompanyName,TEXT]
#define DATA_REQUEST(TEXT) [NSString stringWithFormat:@"http://app.zontenapp.com.cn/%@",TEXT]

#define NAVIGATION_BAR_HEIGHT (44.0f)
#define STATUS_BAR_HEIGHT (20.0f)
#define TOOL_BAR_HEIGHT (44.0f)
#define TAB_BAR_HEIGHT (49.0f)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

#define APP_CONTENT_NOT_NAV (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)
#define APP_CONTENT_NOT_TAB (SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT)
#define APP_CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT)

/*
 故事板
 */
#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define FILE_MANAGER [NSFileManager defaultManager]
#define APP_SHARE [UIApplication sharedApplication]

#pragma mark - degrees/radian functions
/*
 旋转的单位采用弧度(radians),而不是角度（degress）。以下两个函数，你可以在弧度和角度之间切换。
 */
#define DegreesToRadians(degrees) ((degrees) * M_PI / 180.0)
#define RadiansToDegrees(radians) ((radians) * 180.0 / M_PI)

#pragma mark - color functions

#define COLORHEXA(hex,a) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0 \
                                         green:((float)(((hex) & 0xFF00) >> 8)) / 255.0    \
                                          blue:((float)((hex) & 0xFF)) / 255.0             \
                                         alpha:(a)]

#define COLORRGBA(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f                              \
                                           green:(g) / 255.0f                              \
                                            blue:(b) / 255.0f                              \
                                           alpha:(a)]

#define COLORRGB(r,g,b) [UIColor colorWithRed:(r) / 255.0f                                 \
                                        green:(g) / 255.0f                                 \
                                         blue:(b) / 255.0f                                 \
                                        alpha:1.0]

#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0    \
                                      green:((float)(((hex) & 0xFF00) >> 8)) / 255.0       \
                                       blue:((float)((hex) & 0xFF)) / 255.0                \
                                      alpha:1.0]

#define APP_CACHES  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_LIBRARY [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CUT_PLAN(HM_IMAGE,HM_RECT) [UIImage imageWithCGImage:CGImageCreateWithImageInRect([HM_IMAGE CGImage], HM_RECT)]

#define SAFE_RELEASE(x) [x release];x=nil

#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentOrientation [[UIDevice currentDevice] orientation]
#define StatusOrientation [UIApplication sharedApplication].statusBarOrientation
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define CurrentPhone [[UIDevice currentDevice] model]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define HMSTR(fmt,...) [NSString stringWithFormat:(fmt),##__VA_ARGS__]

//use dlog to print while in debug model
#ifdef DEBUG
#define HMLog(fmt, ...) NSLog((@"[Time %s] [Function %s] [Name iyun] [Line %d] " fmt),__TIME__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HMLog(...) while{}(0);
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_AND_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#else
#define IOS7_AND_LATER (0)
#endif

//#if IOS7_AND_LATER
//#define SCORE_URL [@"itms-apps://itunes.apple.com/app/id" stringByAppendingString:APP_ID]
//#else
//#define SCORE_URL [@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" stringByAppendingString:APP_ID]
//#endif

#define isRetina ([UIScreen mainScreen].scale == 2)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

//G－C－D
#define HM_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define HM_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

/*
 保持竖屏
 */
#define HM_PORTRAIT()  \
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation\
{\
return (toInterfaceOrientation == UIInterfaceOrientationPortrait);\
}\
\
\
- (BOOL)shouldAutorotate\
{\
return NO;\
}\
\
- (NSUInteger)supportedInterfaceOrientations\
{\
return UIInterfaceOrientationMaskPortrait;\
}\
\
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation\
{\
return UIInterfaceOrientationPortrait;\
}\

/*
 保持四个方向都可以
 */
#define HM_ORIENTATION_ALL() \
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation\
{\
return YES;\
}\
\
\
- (BOOL)shouldAutorotate\
{\
return YES;\
}\
\
- (NSUInteger)supportedInterfaceOrientations\
{\
return UIInterfaceOrientationMaskAll;\
}\
\
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation\
{\
return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;\
}\

#endif
