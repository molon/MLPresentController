//
//  MLPresentControllerAnimator.m
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "MLPresentControllerAnimator.h"
#import "MLPresentController.h"
#import "MLPresentController+PrivatePropertyAndMethod.h"
//#import "MLPresentView.h"
#import "UIView+FixIOS7BugForMLPresentController.h"

static NSTimeInterval const kDefaultDuration = .25f;

@implementation MLPresentControllerAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = kDefaultDuration;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (IOS_VERSION_MLPRESENTCONTROLLER<8.0) {
        if (!self.isForPresent) {
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//            if ([toVC.view isKindOfClass:[MLPresentView class]]) {
//                ((MLPresentView*)toVC.view).ignoreSetFrame = NO;
//            }
            toVC.view.ignoreSetFrame = NO;
        }
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    [[MLPresentController sharedInstance]recoverPreStateForPresentedViewController];
    
    //IOS8 暂时不需要修正此BUG，因为后来发现iOS8下在下一次present的时候会dealloc上一次没释放的
    if (IOS_VERSION_MLPRESENTCONTROLLER<8.0) {
        //注意此修正也仅仅是在keyWindow上
        if (!transitionCompleted&&self.isForPresent) {
            UIViewController *presentedViewController = [MLPresentController sharedInstance].currentPresentedViewController;
            if (presentedViewController) {
                //修正UIKit BUG，在cancel之后不释放presentedViewController
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                SEL selector = NSSelectorFromString(@"_removeRotationViewController:");
                if ([window respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [window performSelector:selector withObject:presentedViewController];
#pragma clang diagnostic pop
                }
            }
        }
    }
    
    [MLPresentController sharedInstance].currentPresentedViewController = nil;
}

@end
