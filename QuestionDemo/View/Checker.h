//
//  Checker.h
//  QuestionDemo
//
//  Created by G on 2019/12/19.
//  Copyright © 2019 G. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    /// 圆形选框
    CheckerStyleRadio,
    /// 矩形选框
    CheckerStyleChecker,
} CheckerStyle;

/// 选框视图
@interface Checker : UIView

/// 是否选中
@property (assign, nonatomic) BOOL selected;
/// 边框宽度
@property (assign, nonatomic) BOOL borderWidth;
/// 选框类型
@property (assign, nonatomic) CheckerStyle checkerStyle;
/// 选框颜色
@property (strong, nonatomic) UIColor *checkerColor;

@end

NS_ASSUME_NONNULL_END
