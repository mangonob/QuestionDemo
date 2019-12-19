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

-(instancetype)init {
    if (self = [super init]) {
        self.hidden = true;
    }
    return self;
}

-(BOOL)interacte {
    BOOL mutatted = NO;
    
    if (self.parent.type == QuestionTypeSingleChoice) {
        if (!self.selected) {
            mutatted = YES;
        }
        for (Question *question in self.parent.child) {
            question.selected = NO;
            if (question != self && question.type == QuestionTypeOptionWithQuestion) {
                [question close:1];
            }
        }
        self.selected = YES;
    } else if (self.parent.type == QuestionTypeMultiChoice) {
        mutatted = YES;
        self.selected = !self.selected;
    }
    
    if (self.type == QuestionTypeOptionWithQuestion) {
        if (self.selected) {
            [self expand:2];
        } else {
            [self close:1];
        }
    }
    
    return mutatted;
}

-(void)expand:(int)maxDepth {
    if (!maxDepth) {
        return;
    }
    
    for (Question *question in self.child) {
        question.hidden = false;
        [question expand:maxDepth - 1];
    }
}

-(void)close:(int)maxDepth {
    if (!maxDepth) {
        return;
    }
    
    for (Question *question in self.child) {
        question.hidden = true;
        [question close:maxDepth - 1];
    }
}

-(NSArray<Question *> *)descendants {
    NSMutableArray<Question *> *descendants = [[NSMutableArray alloc] init];
    for (Question *child in self.child) {
        // 如果题目没被隐藏
        if (!child.hidden) {
            [descendants addObject:child];
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
    self.parent = parent;
    for (Question *question in self.child) {
        [question validatedWithParent:self];
    }
    return self;
}

#pragma mark - 访问者方法
-(void)visit:(QuestionCellNode *)cell {
    [cell setTitle:self.content];
    if (self.level < 3) {
        [cell setIndentLevel:(CGFloat)self.level];
    } else {
        [cell setLeadingIndentLevel:(CGFloat)self.level];
    }
    
    [cell setTextHidden:
     !(
       self.type == QuestionTypeTextInput ||
       (self.type == QuestionTypeInputOption && self.selected)
       )];
    
    cell.checkerHidden =
    (
     self.type == QuestionTypeSingleChoice ||
     self.type == QuestionTypeMultiChoice ||
     self.type == QuestionTypeTextInput ||
     self.type == QuestionTypeDepartmentChoice
     );
    
    cell.checked = self.selected;
}

-(NSString *)description {
    NSString *questionTypeDescrpiton = @"<unknow>";
    
    switch (self.type) {
        case QuestionTypeOption:
            questionTypeDescrpiton = @"选项";
            break;
        case QuestionTypeDepartmentChoice:
            questionTypeDescrpiton = @"科室选择题";
            break;
        case QuestionTypeTextInput:
            questionTypeDescrpiton = @"输入文本的题目";
            break;
        case QuestionTypeInputOption:
            questionTypeDescrpiton = @"输入文本的选项";
            break;
        case QuestionTypeMultiChoice:
            questionTypeDescrpiton = @"多选题";
            break;
        case QuestionTypeOptionWithQuestion:
            questionTypeDescrpiton = @"拥有子题的选项";
            break;
        case QuestionTypeSingleChoice:
            questionTypeDescrpiton = @"单选题";
            break;
    }
    
    return [NSString stringWithFormat:@"<[%@] %@>", questionTypeDescrpiton, self.content];
}

@end
