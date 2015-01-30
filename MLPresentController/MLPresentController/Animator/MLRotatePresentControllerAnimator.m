//
//  MLRotatePresentControllerAnimator.m
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "MLRotatePresentControllerAnimator.h"
#import "MLPresentController.h"
#import "UIView+Convenience.h"

static NSInteger const kDimmingViewTag = 1024;

@implementation MLRotatePresentControllerAnimator

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
//    UIView *presentingView = self.isForPresent?fromView:toView;
    
    UIView *dimmingView = [containerView viewWithTag:kDimmingViewTag];
    
    if (self.isForPresent) {
        if (!dimmingView) {
            dimmingView = [UIView new];
            dimmingView.frame = containerView.bounds;
            dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            dimmingView.backgroundColor = [UIColor blackColor];
            dimmingView.alpha = 0.01;
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
    
    [self changeAnchorPointY:containerView.frameHeight*2/presentedView.frameHeight andAdjustPositionForView:presentedView];
    
    CGFloat maxFeatAngle = [self maxFeatRangleForView:presentedView withFeatContainerView:containerView];
    
    if (self.isForPresent) {
        [self moveViewWithX:self.isReverse?containerView.frameWidth/2:-containerView.frameWidth/2 forView:presentedView withMaxFeatRangle:maxFeatAngle andFeatContainerView:containerView];
        
        //sorry, spring animator is not allowed
//        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self moveViewWithX:0 forView:presentedView withMaxFeatRangle:maxFeatAngle andFeatContainerView:containerView];
            
            dimmingView.alpha = 0.35f;
        } completion:^(BOOL finished) {
//            NSLog(@"animator present end");
            presentedView.transform = CGAffineTransformIdentity;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            if ([transitionContext transitionWasCancelled]) {
                [dimmingView removeFromSuperview];
            }
        }];
    }else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self moveViewWithX:self.isReverse?containerView.frameWidth/2:-containerView.frameWidth/2 forView:presentedView withMaxFeatRangle:maxFeatAngle andFeatContainerView:containerView];
            
            dimmingView.alpha = 0.01;
        } completion: ^(BOOL finished) {
//            NSLog(@"animator dismiss end");
            if (![transitionContext transitionWasCancelled]) {
                [dimmingView removeFromSuperview];
                [presentedView removeFromSuperview];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }

}


- (void)moveViewWithX:(float)x forView:(UIView*)view withMaxFeatRangle:(CGFloat)maxFeatRangle andFeatContainerView:(UIView*)containerView
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform,maxFeatRangle*(x/(containerView.frameWidth/2)), 0, 0, 1);
    [view.layer setTransform:transform];
}


- (void)changeAnchorPointY:(CGFloat)anchorPointY andAdjustPositionForView:(UIView*)view
{
    NSAssert(anchorPointY>1, @"anchorPoint必须大于1才OK");
    
    CALayer *layer = [view layer];
    CGPoint oldAnchorPoint = layer.anchorPoint;
    [layer setAnchorPoint:CGPointMake(oldAnchorPoint.x, anchorPointY)];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
}

- (CGFloat)maxFeatRangleForView:(UIView*)view withFeatContainerView:(UIView*)containerView
{
    NSAssert(view.layer.anchorPoint.y>1, @"anchorPoint必须大于1才OK");
    
    CGFloat halfViewWidth = (view.frameWidth/2);
    
    
    CGRect inFrame = [view convertRect:view.bounds toView:containerView];
    NSAssert(!CGRectEqualToRect(inFrame, CGRectZero), @"containerView和view必须在同一坐标系里");
    NSAssert(inFrame.origin.x>=0&&inFrame.origin.x+inFrame.size.width<=containerView.frame.size.width, @"containerView和view必须在同一坐标系里");
    
    //判断下左右空间哪个小点。取小的空间宽度+view宽度一半
    CGFloat containerExtraWidth = halfViewWidth;
    if (inFrame.origin.x > containerView.frameWidth-inFrame.origin.x-inFrame.size.width) {
        containerExtraWidth += containerView.frameWidth-inFrame.origin.x-inFrame.size.width;
    }else{
        containerExtraWidth += inFrame.origin.x;
    }
    
    //找到角度范围
    CGFloat r = view.frameHeight*(view.layer.anchorPoint.y-1);
    //view一半的角度
    CGFloat angle1 = atan(halfViewWidth/r);
    CGFloat calcRadius = sqrt(r*r+halfViewWidth*halfViewWidth);
    
    //额外container空间的角度
    CGFloat angle2 = asin(containerExtraWidth/calcRadius);
    NSAssert(angle2<=1, @"请增大anchorPoint.y或者减少containerView宽度或者增大presentedView宽度");
    
    CGFloat angle = angle1+angle2;
    
    return angle;
}

@end
