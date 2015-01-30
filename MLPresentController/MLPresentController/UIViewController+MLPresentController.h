//
//  UIViewController+MLPresentController.h
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPresentControllerAnimator;

/**
 *  此协议与ml_validatePanGesturePresent方法配合使用
 *  切记一定要执行可交互方法
 */
@protocol MLPresentControllerPanDedelagte <NSObject>

@optional
/**
 *  pan从左往右开始需要执行的操作，可present或者dismiss，但是切记一定要使用此类支持交互的方法。
 */
- (BOOL)ml_panGestureBeginFromLeft;
/**
 *  pan从右往左开始需要执行的操作，可present或者dismiss，但是切记一定要使用此类支持交互的方法。
 */
- (BOOL)ml_panGestureBeginFromRight;

@end


@interface UIViewController (MLPresentController)


/**
 *  通常的present方法，使用MLRotatePresentControllerAnimator动画，不可为交互使用
 */
- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion;
/**
 *  通常的present方法，使用MLRotatePresentControllerAnimator动画，但是可定义interactiving决定是否供交互使用
 */
- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent interactiving:(BOOL)interactiving completion:(void (^)(void))completion;
/**
 *  present方法，需要传递自定义MLPresentControllerAnimator动画对象，不可为交互使用
 */
- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent animator:(MLPresentControllerAnimator*)animator completion:(void (^)(void))completion;
/**
 *  present方法，需要传递自定义MLPresentControllerAnimator动画对象，但是可定义interactiving决定是否供交互使用
 */
- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent animator:(MLPresentControllerAnimator*)animator interactiving:(BOOL)interactiving completion:(void (^)(void))completion;


/**
 *  通常的dismiss方法，使用MLRotatePresentControllerAnimator动画，不可为交互使用
 */
- (void)ml_dismissViewControllerWithCompletion:(void (^)(void))completion;
/**
 *  通常的dismiss方法，使用MLRotatePresentControllerAnimator动画，但是可定义interactiving决定是否供交互使用
 */
- (void)ml_dismissViewControllerWithInteractiving:(BOOL)interactiving completion:(void (^)(void))completion;
/**
 *  dismiss方法，需要传递自定义MLPresentControllerAnimator动画对象，不可为交互使用
 */
- (void)ml_dismissViewControllerWithAnimator:(MLPresentControllerAnimator*)animator completion:(void (^)(void))completion;
/**
 *  dismiss方法，需要传递自定义MLPresentControllerAnimator动画对象，但是可定义interactiving决定是否供交互使用
 */
- (void)ml_dismissViewControllerWithAnimator:(MLPresentControllerAnimator*)animator interactiving:(BOOL)interactiving completion:(void (^)(void))completion;

/**
 *  对当前self.view添加pan手势，配合MLPresentControllerPanDedelagte协议可开启交互功能
 */
- (void)ml_validatePanGesturePresent;

/**
 *  可对其enabled与否开关pan功能
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *interactivePresentPanGestureRecognizer;


//for override
/**
 *  默认返回containerView的大小(一般为屏幕大小), 这个是被present的VC需要关心并且继承修改的
 */
- (CGRect)ml_preferredFrameForPresentedWithContainerFrame:(CGRect)containerFrame;

/**
 *  这个是在自定义动画里，如果添加了dimmingView，添加其tap手势可以以此作为action，继承可做自定义实现，一般做dismiss处理
 */
- (void)didTappedDimmingViewWithGesture:(UITapGestureRecognizer*)tapGesture;


@end
