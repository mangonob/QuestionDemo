//
//  Questionnaire.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Question;
@class QuestionnaireConfirmDetails;

/// 问卷调查
@interface Questionnaire : NSObject

/// 题目列表
@property (strong, nonatomic) NSArray<Question *> *que_li;
/// 题目数量
@property (assign, nonatomic) int que_num;
/// 问卷ID
@property (assign, nonatomic) int sur_id;
/// 问卷名称
@property (copy, nonatomic) NSString *sur_name;
/// 前言
@property (copy, nonatomic) NSString *preface;

/**
 @param filename 文件名称（eg: myjson.json），文件需在Bundle.main中
 @return 如果文件存在并合法，则返回Questionnaire实例
 */
+(nullable instancetype) loadFromJSONFile:(NSString *)filename;

-(nullable QuestionnaireConfirmDetails *)confirm;

@end

NS_ASSUME_NONNULL_END
