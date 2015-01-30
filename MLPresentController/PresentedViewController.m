//
//  PresentedViewController.m
//  MLPresentController
//
//  Created by molon on 14/12/30.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "PresentedViewController.h"
#import "MLPresentController.h"
#import "UIView+Convenience.h"
#import "PresentedViewController2.h"

@interface PresentedViewController ()<MLPresentControllerPanDedelagte>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@end

@implementation PresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.150 green:0.595 blue:0.583 alpha:1.000];
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    
    [self ml_validatePanGesturePresent];
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
        [button setTitle:[NSString stringWithFormat:@"present vc2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(presentVC2) forControlEvents:UIControlEventTouchUpInside];
        
        _button = button;
    }
    return _button;
}

- (UILabel *)label
{
    if (!_label) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = [NSString stringWithFormat:@"Pan from %@ to dismiss",!self.isLocateLeft?@"left":@"right"];
        
        _label = label;
    }
    return _label;
}
#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.label.frame = CGRectMake(0, 30, self.view.frameWidth, 60.0f);
    self.button.frame = [self.view midFrameWithHeight:30 width:120];
}

- (CGRect)ml_preferredFrameForPresentedWithContainerFrame:(CGRect)containerFrame
{
    CGFloat width = containerFrame.size.width;
    CGFloat height = containerFrame.size.height;
    
#define kSelfWidth 200.0f
#define kSelfHeight 300.0f
//    return CGRectMake((width-kSelfWidth)/2, (height-kSelfHeight)/2, kSelfWidth, kSelfHeight);
    
    if (self.isLocateLeft) {
        return CGRectMake(0, (height-kSelfHeight)/2, kSelfWidth, kSelfHeight);
    }else{
        return CGRectMake(width-kSelfWidth, (height-kSelfHeight)/2, kSelfWidth, kSelfHeight);
    }
}

#pragma mark - event
- (void)presentVC2
{
    PresentedViewController2 *vc = [PresentedViewController2 new];
    [self ml_presentViewController:vc completion:nil];
}

- (void)dismissWithInteractiving:(BOOL)interactiving
{
    MLRotatePresentControllerAnimator *animator = [MLRotatePresentControllerAnimator new];
    animator.isReverse = !self.isLocateLeft;
    
    [self ml_dismissViewControllerWithAnimator:animator interactiving:interactiving completion:nil];
}

- (void)didTappedDimmingViewWithGesture:(UITapGestureRecognizer *)tapGesture
{
    [self dismissWithInteractiving:NO];
}
#pragma mark - pan dismiss
- (BOOL)ml_panGestureBeginFromLeft
{
    if (self.isLocateLeft) {
        return NO;
    }
    
    [self dismissWithInteractiving:YES];
    
    return YES;
}

- (BOOL)ml_panGestureBeginFromRight
{
    if (!self.isLocateLeft) {
        return NO;
    }
    
    [self dismissWithInteractiving:YES];
    
    return YES;
}
@end
