//
//  UIViewController+MLPresentController.m
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "UIViewController+MLPresentController.h"
#import "MLPresentController.h"
#import "MLPresentControllerAnimator.h"
#import "MLPresentControllerInteractiveTransition.h"
#import "MLPresentController+PrivatePropertyAndMethod.h"
#import <objc/runtime.h>
#import "UIView+FixIOS7BugForMLPresentController.h"

static char interactivePresentPanGestureRecognizerKey;

@interface UIViewController()

@property (nonatomic, strong) UIPanGestureRecognizer *interactivePresentPanGestureRecognizer;

@end

@implementation UIViewController (MLRotatePresentController)

- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion
{
    [self ml_presentViewController:viewControllerToPresent interactiving:NO completion:completion];
}

- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent interactiving:(BOOL)interactiving completion:(void (^)(void))completion
{
    [self ml_presentViewController:viewControllerToPresent animator:nil interactiving:interactiving completion:completion];
}

- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent animator:(MLPresentControllerAnimator*)animator completion:(void (^)(void))completion
{
    [self ml_presentViewController:viewControllerToPresent animator:animator interactiving:NO completion:completion];
}

- (void)ml_presentViewController:(UIViewController *)viewControllerToPresent animator:(MLPresentControllerAnimator*)animator interactiving:(BOOL)interactiving completion:(void (^)(void))completion
{
    if (!animator) {
        animator = [MLRotatePresentControllerAnimator new];
    }
    
    animator.isForInteractiving = interactiving;
    
    MLPresentController *pc = [MLPresentController sharedInstance];
    pc.animator = animator;
    
    pc.recordTransitioningDelegate = viewControllerToPresent.transitioningDelegate;
    pc.recordModalPresentationStyle = viewControllerToPresent.modalPresentationStyle;
    pc.currentPresentedViewController = viewControllerToPresent;
    
    viewControllerToPresent.transitioningDelegate = pc;
    
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}


- (void)ml_dismissViewControllerWithCompletion:(void (^)(void))completion
{
    [self ml_dismissViewControllerWithInteractiving:NO completion:completion];
}

- (void)ml_dismissViewControllerWithInteractiving:(BOOL)interactiving completion:(void (^)(void))completion
{
    [self ml_dismissViewControllerWithAnimator:nil interactiving:interactiving completion:completion];
}

- (void)ml_dismissViewControllerWithAnimator:(MLPresentControllerAnimator*)animator completion:(void (^)(void))completion
{
    [self ml_dismissViewControllerWithAnimator:animator interactiving:NO completion:completion];
}

- (void)ml_dismissViewControllerWithAnimator:(MLPresentControllerAnimator*)animator interactiving:(BOOL)interactiving completion:(void (^)(void))completion
{
    if (!animator) {
        animator = [MLRotatePresentControllerAnimator new];
    }
    
    //找到presented vc
    UIViewController *viewControllerToPresent;
    if (self.presentingViewController) {
        viewControllerToPresent = self;
    }else if (self.presentedViewController) {
        viewControllerToPresent = self.presentedViewController;
    }else{
        [self dismissViewControllerAnimated:YES completion:completion];
        return;
    }
    
    animator.isForInteractiving = interactiving;
    
    MLPresentController *pc = [MLPresentController sharedInstance];
    pc.animator = animator;
    
    pc.recordTransitioningDelegate = viewControllerToPresent.transitioningDelegate;
    pc.recordModalPresentationStyle = viewControllerToPresent.modalPresentationStyle;
    
    viewControllerToPresent.transitioningDelegate = pc;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    //这里在iOS7下需要设置为custom
    if (IOS_VERSION_MLPRESENTCONTROLLER<8.0) {
        pc.currentPresentingViewController = viewControllerToPresent.presentingViewController;
        
        pc.recordModalPresentationStyleOfPresenting = viewControllerToPresent.presentingViewController.modalPresentationStyle;
        pc.currentPresentingViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        //        if ([pc.currentPresentingViewController.view isKindOfClass:[MLPresentView class]]) {
        //            ((MLPresentView*)pc.currentPresentingViewController.view).ignoreSetFrame = YES;
        //        }
        pc.currentPresentingViewController.view.ignoreSetFrame = YES;
    }
    
    [viewControllerToPresent dismissViewControllerAnimated:YES completion:completion];
}

//继承以修改，显示的时候的合适位置
- (CGRect)ml_preferredFrameForPresentedWithContainerFrame:(CGRect)containerFrame
{
    return CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
}


- (void)didTappedDimmingViewWithGesture:(UITapGestureRecognizer*)tapGesture
{
    //可以啥都不做
}

#pragma mark - Interactive
- (void)ml_validatePanGesturePresent
{
    NSAssert([self conformsToProtocol:@protocol(MLPresentControllerPanDedelagte)], @"使用ml_validatePanGesturePresent功能必须实现MLPresentControllerPanDedelagte协议");
    
    if (self.interactivePresentPanGestureRecognizer) {
        return;
    }
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(ml_panGesturePresentCallback:)];
    [self.view addGestureRecognizer:recognizer];
    self.interactivePresentPanGestureRecognizer = recognizer;
}

- (UIPanGestureRecognizer *)interactivePresentPanGestureRecognizer
{
    return objc_getAssociatedObject(self, &interactivePresentPanGestureRecognizerKey);
}

- (void)setInteractivePresentPanGestureRecognizer:(UIPanGestureRecognizer *)interactivePresentPanGestureRecognizer
{
    static NSString * key = @"interactivePresentPanGestureRecognizer";
    
    [self willChangeValueForKey:key];
    objc_setAssociatedObject(self, &interactivePresentPanGestureRecognizerKey, interactivePresentPanGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:key];
}

- (BOOL)ml_panGestureBeginFromLeft
{
    return NO;
}

- (BOOL)ml_panGestureBeginFromRight
{
    return NO;
}

#pragma mark - pan callback
- (void)ml_panGesturePresentCallback:(UIPanGestureRecognizer*)recognizer
{
    UIView *view = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan&&![self.transitionCoordinator isAnimated]) {
        if ([recognizer velocityInView:view].x>0) {
            if ([self ml_panGestureBeginFromLeft]) {
                NSAssert([self.transitionCoordinator isAnimated], @"必须执行animate的present或者dismiss方法");
                MLPresentControllerAnimator *animator = [MLPresentController sharedInstance].animator;
                NSAssert(animator.isForInteractiving, @"必须给予可交互动画对象");
                
                if ([self.transitionCoordinator isAnimated]&&animator.isForInteractiving) {
                    [MLPresentController sharedInstance].currentPanDirection = MLPresentControllerPanDirectionFromLeft;
                    [MLPresentController sharedInstance].isInteractiving = YES;
                    
                    //                DLOG(@"FromLeft present %p",self);
                }
                
                return;
            }
        }else if ([recognizer velocityInView:view].x<0) {
            if ([self ml_panGestureBeginFromRight]) {
                
                NSAssert([self.transitionCoordinator isAnimated], @"必须执行animate的present或者dismiss方法");
                MLPresentControllerAnimator *animator = [MLPresentController sharedInstance].animator;
                NSAssert(animator.isForInteractiving, @"必须给予可交互动画对象");
                
                if ([self.transitionCoordinator isAnimated]&&animator.isForInteractiving) {
                    [MLPresentController sharedInstance].currentPanDirection = MLPresentControllerPanDirectionFromRight;
                    [MLPresentController sharedInstance].isInteractiving = YES;
                    
                    //                DLOG(@"FromRight present %p",self);
                }
                return;
            }
        }
        return;
    }
    
    if (![MLPresentController sharedInstance].isInteractiving) {
        return;
    }
    
#define IS_FROM_LEFT ([MLPresentController sharedInstance].currentPanDirection == MLPresentControllerPanDirectionFromLeft)
    
    CGFloat progress = (IS_FROM_LEFT?[recognizer translationInView:view].x:-[recognizer translationInView:view].x) / (view.bounds.size.width * 1.0f);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        //因为上下距离太多，所以取消
        if (fabs([recognizer translationInView:view].y)>200.0f) {
            //            NSLog(@"因为上下距离太多，所以取消");
            [[MLPresentController sharedInstance].interactiveTransition cancelInteractiveTransition];
            [MLPresentController sharedInstance].isInteractiving = NO;
        }else{
            //中途上下速率太快就认为想取消
            CGPoint velocity = [recognizer velocityInView:view];
            if (fabs(velocity.y)>500.0f) {
                //检测和x速率的比例是不是inf，是的话，说明明显有向下移动的痕迹
                velocity.x = velocity.x==0?0.000001f:velocity.x;
                if (isinf(fabs(velocity.y)/fabs(velocity.x))) {
                    //                    NSLog(@"因为上下速率太快，所以取消");
                    [[MLPresentController sharedInstance].interactiveTransition cancelInteractiveTransition];
                    [MLPresentController sharedInstance].isInteractiving = NO;
                }
            }
        }
        
        if ([MLPresentController sharedInstance].isInteractiving) {
            progress = MIN(0.999, progress);
            progress = MAX(0.001, progress);
            //纠正progress原因：详情见https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
            [[MLPresentController sharedInstance].interactiveTransition updateInteractiveTransition:progress];
        }
    }else if ((recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)) {
        //结束或者取消了手势，根据方向和速率来判断应该完成transition还是取消transition
        CGFloat velocityX = [recognizer velocityInView:view].x; //我们只关心x的速率
        
        velocityX = IS_FROM_LEFT?velocityX:-velocityX;
        
#define kTooFastVelocity 350.0f
        if (velocityX > kTooFastVelocity) { //向右速率太快就完成
            [[MLPresentController sharedInstance].interactiveTransition finishInteractiveTransition];
        }else if (velocityX < -kTooFastVelocity){ //向左速率太快就取消
            [[MLPresentController sharedInstance].interactiveTransition cancelInteractiveTransition];
        }else{
            if (progress > 0.7f || (progress>=0.10f&&velocityX>0.0f)) {
                [[MLPresentController sharedInstance].interactiveTransition finishInteractiveTransition];
            }else{
                [[MLPresentController sharedInstance].interactiveTransition cancelInteractiveTransition];
            }
        }
        [MLPresentController sharedInstance].isInteractiving = NO;
    }
    
}

@end
