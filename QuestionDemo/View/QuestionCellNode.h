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

@class QuestionCellNode;

@protocol QuestionCellNodeVisitor
-(void)visit:(QuestionCellNode *)cell;
@end

@interface QuestionCellNode : ASCellNode

@property (assign, nonatomic) CGFloat indentLevel;
@property (assign, nonatomic) CGFloat leadingIndentLevel;
@property (assign, nonatomic) CGFloat trailingIndentLevel;
@property (assign, nonatomic) BOOL textHidden;
/// 选中按钮是否隐藏
@property (assign, nonatomic) BOOL checkerHidden;
@property (copy, nonatomic) NSString* text;

/// 是否被选中
@property (assign, nonatomic) BOOL checked;

/// 选中按钮
@property (strong, readonly) CheckerNode *checkerNode;

-(void)setTitle:(NSString *)title;

-(instancetype)accept:(id <QuestionCellNodeVisitor>)visitor;

@end

NS_ASSUME_NONNULL_END
