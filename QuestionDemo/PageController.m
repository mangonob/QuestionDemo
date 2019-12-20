//
//  PageController.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "PageController.h"
#import "Questionnaire.h"
#import "QuestionController.h"
#import "Question.h"
#import "QuestionnaireConfirmDetails.h"
#import <MJExtension/MJExtension.h>

@interface PageController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, QuestionControllerDelegate>
@end

@implementation PageController

-(instancetype)init {
    return [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
}

-(void)setQuesetionnaire:(Questionnaire *)quesetionnaire {
    _quesetionnaire = quesetionnaire;
    
    if ([_quesetionnaire.que_li count]) {
        QuestionController *questionController = [[QuestionController alloc] initWithQuestion: _quesetionnaire.que_li[0]];
        questionController.delegate = self;
        [self setViewControllers:@[
            questionController
        ] direction:UIPageViewControllerNavigationDirectionForward
                        animated:false completion:nil];
    } else {
        [self setViewControllers:nil direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.quesetionnaire = [Questionnaire loadFromJSONFile:@"心内科随访问卷模版.json"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"提交"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(confirmAction:)];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self nextQuestionControllerOf:viewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self prevQuestionControllerOf:viewController];
}

-(QuestionController *)prevQuestionControllerOf:(UIViewController *)controller {
    if ([controller isMemberOfClass:[QuestionController class]]) {
        QuestionController *questionController = (QuestionController *)controller;
        Question *question = questionController.question;
        NSUInteger index = [self.quesetionnaire.que_li indexOfObject:question] - 1;
        if (index < self.quesetionnaire.que_li.count) {
            QuestionController *questionController = [[QuestionController alloc] initWithQuestion:self.quesetionnaire.que_li[index]];
            questionController.delegate = self;
            return questionController;
        }
    }
    return nil;
}

-(QuestionController *)nextQuestionControllerOf:(UIViewController *)controller {
    if ([controller isMemberOfClass:[QuestionController class]]) {
        QuestionController *questionController = (QuestionController *)controller;
        Question *question = questionController.question;
        NSUInteger index = [self.quesetionnaire.que_li indexOfObject:question] + 1;
        if (index < self.quesetionnaire.que_li.count) {
            QuestionController *questionController = [[QuestionController alloc] initWithQuestion:self.quesetionnaire.que_li[index]];
            questionController.delegate = self;
            return questionController;
        }
    }
    return nil;
}

-(QuestionController *)gotoQuestion:(Question *)question {
    QuestionController *currentController = (QuestionController *)self.viewControllers.firstObject;
    Question *currentQuestion = [currentController question];
    NSUInteger currentIndex = [self.quesetionnaire.que_li indexOfObject:currentQuestion];
    NSUInteger index = [self.quesetionnaire.que_li indexOfObject:question];
    if (index < currentIndex) {
        QuestionController *controller = [[QuestionController alloc] initWithQuestion:question];
        controller.delegate = self;
        [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:true completion:nil];
        return controller;
    } else if (index > currentIndex) {
        QuestionController *controller = [[QuestionController alloc] initWithQuestion:question];
        controller.delegate = self;
        [self setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
        return controller;
    } else {
        return currentController;
    }
}

#pragma mark - QuesetionControllerDelegate
-(void)questionController:(QuestionController *)controller performAction:(QuestionControllerAction)action {
    switch (action) {
        case QuestionControllerActionPrev:
        {
            QuestionController *questionController = [self prevQuestionControllerOf:controller];
            if (questionController) {
                [self setViewControllers:@[questionController] direction:UIPageViewControllerNavigationDirectionReverse animated:true completion:nil];
            }
            break;
        }
        case QuestionControllerActionNext:
        {
            QuestionController *questionController = [self nextQuestionControllerOf:controller];
            if (questionController) {
                [self setViewControllers:@[questionController] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
            }
            break;
        }
        case QuestionControllerActionConfirm:
        {
            [self confirm];
            break;
        }
    };
}

-(void)confirm {
    QuestionnaireConfirmDetails *details = [self.quesetionnaire confirm];
    if (details.valid) {
        NSString *answerString = [self.quesetionnaire mj_JSONString];
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"提交成功"
                                    message: answerString
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
        // UIAlertController显示字符串有长度限制，控制台打印一次完整结果
        printf("%s", [answerString cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        NSUInteger uncompletedCount = [details uncompletedQuestion].count;
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"提示"
                                    message:[NSString stringWithFormat:@"您还有 %lu 道题未完成，请先完成所有题目。", (unsigned long)uncompletedCount]
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        NSArray<Question *> *questions = [details firstUncompletedLink];
        [questions firstObject];
        [self presentViewController:alert animated:true completion:nil];
        [[self gotoQuestion:[questions firstObject]] scrollQuestionToVisiable:[questions lastObject]];
    }
}

#pragma mark - Action
-(void)confirmAction:(id)sender {
    [self confirm];
}

@end
