//
//  Question.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionCellNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    /// 科室选择题
    QuestionTypeDepartmentChoice = 1,
    /// 单选题
    QuestionTypeSingleChoice = 2,
    /// 多选题
    QuestionTypeMultiChoice = 3,
    /// 带有子题目的选项
    QuestionTypeOptionWithQuestion = 4,
    /// 文本输入题
    QuestionTypeTextInput = 5,
    /// 选项
    QuestionTypeOption = 6,
    /// 文本输入选项
    QuestionTypeInputOption = 7,
} QuestionType;

/// 题目
@interface Question : NSObject <QuestionCellNodeVisitor>

/// 题面
@property (copy, nonatomic) NSString *content;
/// 答案
@property (copy, nonatomic) NSString *answer;
/// 题目类型
@property (assign, nonatomic) QuestionType type;
/// Code
@property (assign, nonatomic) int code;
/// 子题
@property (strong, nonatomic) NSArray<Question *> *child;
/// 特定题型的文本最大长度限制
@property (assign, nonatomic) int maxLength;

#pragma mark - 非模型解析属性
/// 子题（作为选项时）是否选中
@property (assign, nonatomic) BOOL selected;
/// 在树中的层数，根节点层数为0
@property (assign, nonatomic) int level;
/// 是否是第一个子节点
@property (assign, nonatomic) BOOL tail;
/// 是否是最后一个子节点
@property (assign, nonatomic) BOOL head;
/// 是否显示
@property (assign, nonatomic) BOOL hidden;
/// 父节点
@property (weak, readonly) Question *parent;
/// 所有子孙节点
@property (strong, readonly) NSArray<Question *> *descendants;

- (instancetype)validated;

- (void)expand:(int)maxDepth;
- (void)close:(int)maxDepth;
- (BOOL)interacte;
@end

NS_ASSUME_NONNULL_END
