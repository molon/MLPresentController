//
//  MLPresentController+PrivatePropertyAndMethod.h
//  MSHandbook
//
//  Created by molon on 14/12/26.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "MLPresentController.h"

@class MLPresentControllerAnimator;
@class MLPresentControllerInteractiveTransition;
@interface MLPresentController (PrivatePropertyAndMethod)

@property (nonatomic, assign) BOOL isInteractiving;
@property (nonatomic, strong) MLPresentControllerInteractiveTransition *interactiveTransition;

@property (nonatomic, weak) UIViewController *currentPresentedViewController;
@property (nonatomic, weak) MLPresentControllerAnimator *animator;
@property (nonatomic, weak) id<UIViewControllerTransitioningDelegate> recordTransitioningDelegate;
@property (nonatomic, assign) UIModalPresentationStyle recordModalPresentationStyle;
@property (nonatomic, assign) MLPresentControllerPanDirection currentPanDirection;

- (void)recoverPreStateForPresentedViewController;


@end
