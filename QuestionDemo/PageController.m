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

@interface PageController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation PageController

-(void)setQuesetionnaire:(Questionnaire *)quesetionnaire {
    _quesetionnaire = quesetionnaire;
    
    if ([_quesetionnaire.que_li count]) {
        [self setViewControllers:@[
            [[QuestionController alloc] initWithQuestion: _quesetionnaire.que_li[0]]
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

@end
