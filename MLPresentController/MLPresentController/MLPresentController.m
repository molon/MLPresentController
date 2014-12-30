//
//  MLPresentController.m
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "MLPresentController.h"
#import "MLRotatePresentControllerAnimator.h"
#import "MLPresentControllerInteractiveTransition.h"

@interface MLPresentController()

@property (nonatomic, assign) BOOL isInteractiving;
@property (nonatomic, strong) MLPresentControllerInteractiveTransition *interactiveTransition;


@property (nonatomic, weak) UIViewController *currentPresentedViewController;
@property (nonatomic, weak) MLPresentControllerAnimator *animator;
@property (nonatomic, weak) id<UIViewControllerTransitioningDelegate> recordTransitioningDelegate;
@property (nonatomic, assign) UIModalPresentationStyle recordModalPresentationStyle;
@property (nonatomic, assign) MLPresentControllerPanDirection currentPanDirection;


- (void)recoverPreStateForPresentedViewController;

@end

@implementation MLPresentController

+ (instancetype)sharedInstance {
    static MLPresentController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self class] new];
    });
    return _sharedInstance;
}

#pragma mark - other
- (void)recoverPreStateForPresentedViewController
{
    self.currentPresentedViewController.modalPresentationStyle = self.recordModalPresentationStyle;
    self.currentPresentedViewController.transitioningDelegate = self.recordTransitioningDelegate;
    
    self.recordTransitioningDelegate = nil;
    self.recordModalPresentationStyle = UIModalPresentationFullScreen;
    self.isInteractiving = NO;
    self.animator = nil;
    self.currentPanDirection = MLPresentControllerPanDirectionFromLeft;
}

#pragma mark - delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.animator.isForPresent = YES;
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animator.isForPresent = NO;
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if ([animator isEqual:self.animator]&&self.animator.isForInteractiving) {
        self.interactiveTransition = [MLPresentControllerInteractiveTransition new];
        return self.interactiveTransition;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if ([animator isEqual:self.animator]&&self.animator.isForInteractiving) {
        self.interactiveTransition = [MLPresentControllerInteractiveTransition new];
        return self.interactiveTransition;
    }
    return nil;
}

@end
