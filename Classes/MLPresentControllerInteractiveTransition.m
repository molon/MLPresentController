//
//  MLPresentControllerInteractiveTransition.m
//  MSHandbook
//
//  Created by molon on 14/12/26.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "MLPresentControllerInteractiveTransition.h"

@implementation MLPresentControllerInteractiveTransition
{
    BOOL _isStarted;
    BOOL _isWrong;
}

- (CGFloat)completionSpeed
{
    CGFloat speed = 1-self.percentComplete;
    speed = MAX(speed, 0.001);
    speed = MIN(speed, 0.999);
    
    return speed;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_isWrong) {
        //这个是因为偶尔第一次开启app时候start有延迟，但是手势callback已经执行了finish等其他然后抬起触摸了，这会莫名延迟的start就没有对应的结束时间引起界面假死
        [super startInteractiveTransition:transitionContext];
        
        NSLog(@"发现错误,直接结束此次处理开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super updateInteractiveTransition:0.01f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super finishInteractiveTransition];
                NSLog(@"错误结束处理完毕");
                _isWrong = NO;
                _isStarted = NO;
            });
        });
        [super performSelector:@selector(cancelInteractiveTransition) withObject:nil afterDelay:0.1];
        return;
    }
    [super startInteractiveTransition:transitionContext];
    
    _isStarted = YES;
//    NSLog(@"startInteractiveTransition:%p",self);
}

- (void)finishInteractiveTransition {
    if (!_isStarted) {
        NSLog(@"未start就finish %p",self);
        _isWrong = YES;
        return;
    }
    [super finishInteractiveTransition];
    _isStarted = NO;
//    NSLog(@"finishInteractiveTransition:%p",self);
}

- (void)cancelInteractiveTransition {
    if (!_isStarted) {
        NSLog(@"未start就cancel %p",self);
        _isWrong = YES;
        return;
    }
    [super cancelInteractiveTransition];
    _isStarted = NO;
//    NSLog(@"cancelInteractiveTransition:%p",self);
    
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (!_isStarted) {
        NSLog(@"未start就update %p",self);
        _isWrong = YES;
        return;
    }
    [super updateInteractiveTransition:percentComplete];
//    NSLog(@"updateInteractiveTransition %f:%p",percentComplete,self);
}

@end
