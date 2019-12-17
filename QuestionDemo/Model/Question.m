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

@interface Question ()
@property (weak, readwrite) Question *parent;
@end

@implementation Question
@synthesize descendants;

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

-(NSArray<Question *> *)descendants {
    NSMutableArray<Question *> *descendants = [[NSMutableArray alloc] init];
    for (Question *child in self.child) {
        [descendants addObject:child];
        
        // 如果题目被选中则展开子题
        if (child.selected) {
            [descendants addObjectsFromArray:child.descendants];
        }
    }
    return descendants;
}

/// 初始化模型
-(instancetype)validated {
    [self.child firstObject].head = YES;
    [self.child lastObject].tail = YES;
    for (Question *question in self.child) {
        [question validatedWithParent:self];
    }
    return self;
}


-(instancetype)validatedWithParent:(Question *)parent {
    self.level = parent.level + 1;
    self.parent = self;
    for (Question *question in self.child) {
        [question validatedWithParent:self];
    }
    return self;
}

-(void)visit:(QuestionCellNode *)cell {
    [cell setText:self.content];
    if (self.level < 3) {
        [cell setIndentLevel:(CGFloat)self.level];
    } else {
        [cell setLeadingIndentLevel:(CGFloat)self.level];
    }
}

@end
