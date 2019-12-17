//
//  QuestionController.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Question;

/// 题目控制器
@interface QuestionController : ASViewController<ASDisplayNode *>

/// 题目
@property (strong, nonatomic) Question *question;

-(instancetype) initWithQuestion:(Question *)question;

@end

NS_ASSUME_NONNULL_END
