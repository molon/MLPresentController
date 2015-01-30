//
//  UIView+FixIOS7BugForMLPresentController.m
//  MSHandbook
//
//  Created by molon on 15/1/17.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "UIView+FixIOS7BugForMLPresentController.h"
#import <objc/runtime.h>

NSString * const kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController = @"com.molon.UIView.kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController";

//静态就交换静态，实例方法就交换实例方法
void Swizzle_FixIOS7BugForMLPresentController(Class c, SEL origSEL, SEL newSEL)
{
    //获取实例方法
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!origMethod) {
        //获取静态方法
        origMethod = class_getClassMethod(c, origSEL);
        newMethod = class_getClassMethod(c, newSEL);
    }else{
        newMethod = class_getInstanceMethod(c, newSEL);
    }
    
    if (!origMethod||!newMethod) {
        return;
    }
    
    //自身已经有了就添加不成功，直接交换即可
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        //添加成功一般情况是因为，origSEL本身是在c的父类里。这里添加成功了一个继承方法。
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIView (FixIOS7BugForMLPresentController)

- (BOOL)ignoreSetFrame
{
    return [objc_getAssociatedObject(self, &kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController) boolValue] ;
}

- (void)setIgnoreSetFrame:(BOOL)ignoreSetFrame
{
    [self willChangeValueForKey:kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController];
    objc_setAssociatedObject(self, &kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController, @(ignoreSetFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self willChangeValueForKey:kIgnoreSetFrameKeyOfFixIOS7BugForMLPresentController];
}

- (void)__MLPresentController__hookSetFrame:(CGRect)frame
{
    if (self.ignoreSetFrame) {
        return;
    }
    
    [self __MLPresentController__hookSetFrame:frame];
}

+ (void)load
{
    //8.0以后不需要此修正
    if (IOS_VERSION_MLPRESENTCONTROLLER<8.0) {
        Swizzle_FixIOS7BugForMLPresentController([self class], @selector(setFrame:), @selector(__MLPresentController__hookSetFrame:));
    }
}

@end
