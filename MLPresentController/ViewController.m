//
//  ViewController.m
//  MLPresentController
//
//  Created by molon on 14/12/30.
//  Copyright (c) 2014年 molon. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Convenience.h"
#import "MLPresentController.h"
#import "PresentedViewController.h"

@interface ViewController ()<MLPresentControllerPanDedelagte>

@property (nonatomic, strong) UIButton *leftButtton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MLPresentController";
    
    [self.view addSubview:self.leftButtton];
    [self.view addSubview:self.rightButton];
    
    [self ml_validatePanGesturePresent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIButton *)leftButtton
{
    if (!_leftButtton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"left" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _leftButtton = button;
    }
    return _leftButtton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"right" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _rightButton = button;
    }
    return _rightButton;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
#define kButtonWidth 80.0f
#define kButtonHeight 30.0f
    
    CGRect midFrame = [self.view midFrameWithHeight:kButtonHeight width:kButtonWidth];
    
    midFrame.origin.x = 10.0f;
    self.leftButtton.frame = midFrame;
    
    midFrame.origin.x = self.view.frameWidth-10.0f-kButtonWidth;
    self.rightButton.frame = midFrame;
}

#pragma mark - event

- (void)presentVCWithIsLocateLeft:(BOOL)isLocateLeft interactiving:(BOOL)interactiving
{
    PresentedViewController *vc = [PresentedViewController new];
    vc.isLocateLeft = isLocateLeft;
    
    MLRotatePresentControllerAnimator *animator = [MLRotatePresentControllerAnimator new];
    animator.isReverse = !isLocateLeft;
    
    [self ml_presentViewController:vc animated:YES animator:animator interactiving:interactiving completion:nil];
}

- (void)leftPressed
{
    [self presentVCWithIsLocateLeft:YES interactiving:NO];
}

- (void)rightPressed
{
    [self presentVCWithIsLocateLeft:NO interactiving:NO];
}

#pragma mark - pan present
- (BOOL)ml_panGestureBeginFromLeft
{
    [self presentVCWithIsLocateLeft:YES interactiving:YES];
    return YES;
}

- (BOOL)ml_panGestureBeginFromRight
{
    [self presentVCWithIsLocateLeft:NO interactiving:YES];
    return YES;
}

@end
