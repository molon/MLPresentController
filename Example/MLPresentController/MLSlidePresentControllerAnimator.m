//
//  MLSlidePresentControllerAnimator.m
//  MSHandbook
//
//  Created by molon on 15/1/5.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLSlidePresentControllerAnimator.h"
#import "MLPresentController.h"

static NSInteger const kDimmingViewTag = 1029;

@implementation MLSlidePresentControllerAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.20f;
    }
    return self;
}

- (void)dealloc
{
//    DLOG(@"dealloc %@",NSStringFromClass([self class]));
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super animateTransition:transitionContext];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView,*toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    fromView = fromView?fromView:fromVC.view;
    toView = toView?toView:toVC.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *presentedViewController = self.isForPresent?toVC:fromVC;
    UIView *presentedView = self.isForPresent?toView:fromView;
    
//    UIViewController *presentingViewController = self.isForPresent?fromVC:toVC;
//    UIView *presentingView = self.isForPresent?fromView:toView;
    
    UIView *dimmingView = [containerView viewWithTag:kDimmingViewTag];
    
    if (self.isForPresent) {
        if (!dimmingView) {
            dimmingView = [UIView new];
            dimmingView.frame = containerView.bounds;
            dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            dimmingView.backgroundColor = [UIColor clearColor];
            dimmingView.tag = kDimmingViewTag;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:presentedViewController action:@selector(didTappedDimmingViewWithGesture:)];
            dimmingView.userInteractionEnabled = YES;
            [dimmingView addGestureRecognizer:tapGesture];
            
            [containerView addSubview:dimmingView];
        }
        
        presentedView.layer.cornerRadius = 4.0f;
        presentedView.clipsToBounds = YES;
        
        presentedView.frame = [presentedViewController ml_preferredFrameForPresentedWithContainerFrame:containerView.frame];
        [containerView addSubview:presentedView];
    }
    
    //先搞个简单的放大缩小动画
    if (self.isForPresent) {
        //从中间展开的动画
        presentedView.transform = CGAffineTransformMakeScale(1.0,0.001);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [dimmingView removeFromSuperview];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            presentedView.transform = CGAffineTransformMakeScale(1.0,0.001);
            
        } completion: ^(BOOL finished) {
            if (![transitionContext transitionWasCancelled]) {
                [dimmingView removeFromSuperview];
                [presentedView removeFromSuperview];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

@end
