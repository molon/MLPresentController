//
//  PresentedViewController2.m
//  MLPresentController
//
//  Created by molon on 15/1/30.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "PresentedViewController2.h"
#import "UIView+convenience.h"
#import "MLPresentController.h"
#import "MLSlidePresentControllerAnimator.h"

@interface PresentedViewController2 ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation PresentedViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.555 blue:0.458 alpha:1.000];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIButton *)button
{
    if (!_button) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"dismiss" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _button = button;
    }
    return _button;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.button.frame = [self.view midFrameWithHeight:30 width:120];
}

- (CGRect)ml_preferredFrameForPresentedWithContainerFrame:(CGRect)containerFrame
{
    return CGRectInset(containerFrame, 20, 150);
}

#pragma mark - event
- (void)dismiss
{
    MLSlidePresentControllerAnimator *animator = [MLSlidePresentControllerAnimator new];
    animator.isForPresent = NO;
    
    [self ml_dismissViewControllerWithAnimator:animator completion:nil];
}

- (void)didTappedDimmingViewWithGesture:(UITapGestureRecognizer *)tapGesture
{
    [self dismiss];
}

@end
