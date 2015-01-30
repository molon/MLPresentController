//
//  UIView+FixIOS7BugForMLPresentController.h
//  MSHandbook
//
//  Created by molon on 15/1/17.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>


#define IOS_VERSION_MLPRESENTCONTROLLER ([[[UIDevice currentDevice] systemVersion]floatValue])

@interface UIView (FixIOS7BugForMLPresentController)

@property (nonatomic, assign) BOOL ignoreSetFrame;

@end
