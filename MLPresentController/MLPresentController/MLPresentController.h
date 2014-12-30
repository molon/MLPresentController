//
//  MLPresentController.h
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPresentControllerAnimator.h"
#import "MLRotatePresentControllerAnimator.h"

/**
 *  主要的可使用需要关心的方法在下面这个类目里
 */
#import "UIViewController+MLPresentController.h"

typedef NS_ENUM(NSUInteger, MLPresentControllerPanDirection) {
    MLPresentControllerPanDirectionFromLeft = 0,
    MLPresentControllerPanDirectionFromRight,
};

@interface MLPresentController : NSObject<UIViewControllerTransitioningDelegate>

+ (instancetype)sharedInstance;


@end
