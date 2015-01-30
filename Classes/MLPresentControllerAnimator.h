//
//  MLPresentControllerAnimator.h
//  MSHandbook
//
//  Created by molon on 14/12/25.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPresentControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isForInteractiving;
@property (nonatomic, assign) BOOL isForPresent;
@property (nonatomic, assign) NSTimeInterval duration;


@end
