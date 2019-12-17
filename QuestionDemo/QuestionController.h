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
@class QuestionController;

typedef enum {
    QuestionControllerActionPrev,
    QuestionControllerActionNext,
    QuestionControllerActionConfirm,
}QuestionControllerAction;

/// QuestionController代理
@protocol QuestionControllerDelegate

@optional
-(void)questionController:(QuestionController *)controller performAction:(QuestionControllerAction)action;

@end


/// 题目控制器
@interface QuestionController : ASViewController<ASDisplayNode *>

/// 题目
@property (strong, nonatomic) Question *question;

/// 代理对象
@property (weak, nonatomic) id<QuestionControllerDelegate> delegate;

-(instancetype) initWithQuestion:(Question *)question;

@end

NS_ASSUME_NONNULL_END
