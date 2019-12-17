//
//  Question.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "Question.h"
#import <MJExtension/MJExtension.h>
#import "QuestionCellNode.h"

@implementation Question

+ (void)initialize
{
    if (self == [Question class]) {
        // MJExtension嵌套模型解析初始化
        [self mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"child": NSStringFromClass(self),
            };
        }];
    }
}

-(void)visit:(QuestionCellNode *)cell {
    [cell setText:self.content];
}

@end
