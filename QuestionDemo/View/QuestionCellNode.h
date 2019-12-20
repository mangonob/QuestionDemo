//
//  QuestionCellNode.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CheckerNode.h"

NS_ASSUME_NONNULL_BEGIN

@class Question;
@class QuestionCellNode;

@protocol QuestionCellNodeVisitor
-(void)visit:(QuestionCellNode *)cell;
@end

@interface QuestionCellNode : ASCellNode

/// 缩进等级，修改该值会同时影响到前置缩进，以及后置缩进
@property (assign, nonatomic) CGFloat indentLevel;
/// 前置缩减等级
@property (assign, nonatomic) CGFloat leadingIndentLevel;
@property (assign, nonatomic) CGFloat trailingIndentLevel;
/// 文本框是否隐藏（default: YES）
@property (assign, nonatomic) BOOL textHidden;
/// 选中按钮是否隐藏
@property (assign, nonatomic) BOOL checkerHidden;
/// 文本框的内容
@property (copy, nonatomic) NSString* text;

/// 是否被选中
@property (assign, nonatomic) BOOL checked;

/// 选中按钮
@property (strong, readonly) CheckerNode *checkerNode;

/// 对模型的弱引用
@property (weak, nonatomic) Question *question;

/// 设置标题
-(void)setTitle:(NSString *)title;

/// 受访方法（视图 <- 模型）
-(instancetype)accept:(id <QuestionCellNodeVisitor>)visitor;

@end

NS_ASSUME_NONNULL_END
