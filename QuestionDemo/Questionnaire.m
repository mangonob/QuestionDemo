//
//  Questionnaire.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "Questionnaire.h"
#import "Question.h"
#import <MJExtension/MJExtension.h>

@implementation Questionnaire

+ (void)initialize
{
    if (self == [Questionnaire class]) {
        // MJExtension嵌套模型解析初始化
        [self mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"que_li": NSStringFromClass([Question class]),
            };
        }];
    }
}

+ (instancetype)loadFromJSONFile:(NSString *)filename {
    NSArray<NSString *> *components = [filename componentsSeparatedByString:@"."];

    if (components.count == 2) {
        NSData *jsonData =
        [NSData dataWithContentsOfURL: [[NSBundle mainBundle] URLForResource:components[0]
                                                               withExtension:components[1]]];
        
        return [Questionnaire mj_objectWithKeyValues: [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil]];
    }
    
    return nil;
}

@end
