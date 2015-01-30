//
//  MLPresentView.m
//  MSHandbook
//
//  Created by molon on 15/1/17.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLPresentView.h"

@implementation MLPresentView

- (void)setFrame:(CGRect)frame
{
    if (self.ignoreSetFrame) {
        return;
    }
    
    [super setFrame:frame];
}

@end
