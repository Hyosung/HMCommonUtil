//
//  UIAlertView+HM.m
//  HMCommUtil
//
//  Created by ismallstar on 13-12-26.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import "UIAlertView+HM.h"

#undef HMUIAlertViewClickedButtonKey
#define HMUIAlertViewClickedButtonKey @"UIAlertView.clickedButton"

#undef HMUIAlertViewCanelKey
#define HMUIAlertViewCanelKey @"UIAlertView.cancel"

#undef HMUIAlertViewWillPresentKey
#define HMUIAlertViewWillPresentKey @"UIAlertView.willPresent"

#undef HMUIAlertViewDidPresentKey
#define HMUIAlertViewDidPresentKey @"UIAlertView.didPresent"

#undef HMUIAlertViewWillDismissKey
#define HMUIAlertViewWillDismissKey @"UIAlertView.willDismiss"

#undef HMUIAlertViewDidDismissKey
#define HMUIAlertViewDidDismissKey @"UIAlertView.didDismiss"

#undef HMUIAlertViewShouldEnableFirstOtherButtonKey
#define HMUIAlertViewShouldEnableFirstOtherButtonKey @"UIAlertView.shouldEnableFirstOtherButton"

@implementation UIAlertView (HM)

- (void)handlerClickedButton:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewClickedButtonKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerCancel:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewCanelKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerWillPresent:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewWillPresentKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerDidPresent:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewDidPresentKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerWillDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewWillDismissKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerDidDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewDidDismissKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerShouldEnableFirstOtherButton:(BOOL(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, HMUIAlertViewShouldEnableFirstOtherButtonKey, anBlock, OBJC_ASSOCIATION_COPY);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, HMUIAlertViewClickedButtonKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, HMUIAlertViewCanelKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, HMUIAlertViewWillPresentKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, HMUIAlertViewDidPresentKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, HMUIAlertViewWillDismissKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, HMUIAlertViewDidDismissKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    BOOL (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, HMUIAlertViewShouldEnableFirstOtherButtonKey);
    if (anBlock) {
        return anBlock(alertView);
    }
    return YES;
}

@end
