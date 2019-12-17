//
//  PageController.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Questionnaire;

@interface PageController : UIPageViewController

/// 问卷
@property (strong, nonatomic) Questionnaire *quesetionnaire;

@end

NS_ASSUME_NONNULL_END
