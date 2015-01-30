//
//  MLPresentView.h
//  MSHandbook
//
//  Created by molon on 15/1/17.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

//这个原因是下面，但是现在暂时还是用hook方式吧
/**
 *  为了修正iOS7的一个BUG存在的,为了解决BUG，设计上很丑陋啊，如果runtime去hook setFrame的话又怕太降低性能
 *  如果在custom frame 的presented vc1上再present一个vc2，vc2dismiss的时候iOS7下会把vc1的orgin设置为CGPointZero，所以如果想避免此种情况，可让vc1.view 设置为MLPresentView即可，其他的都在MLPresentController里内部处理了。
 */
@interface MLPresentView : UIView

@property (nonatomic, assign) BOOL ignoreSetFrame;

@end
