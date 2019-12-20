//
//  QuestionnaireConfirmDetails.h
//  QuestionDemo
//
//  Created by G on 2019/12/20.
//  Copyright © 2019 G. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Question;
@class Questionnaire;

/// 问卷提交结果
@interface QuestionnaireConfirmDetails : NSObject

-(instancetype)initWithQuestionnaire:(Questionnaire *)questionnaire;

/// 提交是否合法
@property (assign, readonly) BOOL valid;
/// 没完成的大题
@property (strong, readonly, nullable) NSArray<Question *> *uncompletedQuestion;
/// 没完成的所有题目
@property (strong, readonly, nullable) NSArray<Question *> *flatUncompletedQuestion;
/// 所有未完成的最小子题
@property (strong, readonly, nullable) NSArray<Question *> *terminatedUncompletedQuestion;

/// 某题下没完成的子题
-(nullable NSArray<Question *> *)uncompletedQuestionUnderQuestion:(Question *)question;

/// 未完成的题目路径
-(NSArray<NSNumber*> *)pathOfQuestion:(Question *)question;

/** 题目链
 @param question 子题
 @returns 从最外层的题目到子题，经过的所有题目（包含最外层的题目以及传入的子题）
 */
-(NSArray<Question *> *)linkOfQuestion:(Question *)question;

/// 第一个未完成的题目链
-(NSArray<Question *> *)firstUncompletedLink;

@end

NS_ASSUME_NONNULL_END
