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
        if (index >= 0 && index < self.quesetionnaire.que_li.count) {
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
        if (index >= 0  && index < self.quesetionnaire.que_li.count) {
            QuestionController *questionController = [[QuestionController alloc] initWithQuestion:self.quesetionnaire.que_li[index]];
            questionController.delegate = self;
            return questionController;
        }
    }
    return nil;
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
            break;
        }
    };
}

@end
