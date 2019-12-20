//
//  QuestionnaireConfirmDetails.m
//  QuestionDemo
//
//  Created by G on 2019/12/20.
//  Copyright © 2019 G. All rights reserved.
//

#import "QuestionnaireConfirmDetails.h"
#import "Questionnaire.h"
#import "Question.h"

@interface QuestionnaireConfirmDetails()

@property (weak, nonatomic) Questionnaire *questionnaire;

@end

@implementation QuestionnaireConfirmDetails

-(instancetype)initWithQuestionnaire:(Questionnaire *)questionnaire {
    if (self = [super init]) {
        self.questionnaire = questionnaire;
    }
    
    return self;
}

-(BOOL)valid {
    return ![self.uncompletedQuestion count];
}

-(NSArray<Question *> *)uncompletedQuestion {
    NSMutableArray<Question *> *questions = [NSMutableArray new];
    
    for (Question *question in self.questionnaire.que_li) {
        if (!question.completed) {
            [questions addObject:question];
        }
    }
    
    return questions;
}

- (NSArray<Question *> *)flatUncompletedQuestion {
    NSMutableArray<Question *> *questions = [NSMutableArray new];
    
    for (Question *question in self.questionnaire.que_li) {
        if (!question.completed) {
            [questions addObject:question];
            [questions addObjectsFromArray:[self uncompletedQuestionUnderQuestion:question]];
        }
    }
    
    return questions;
}

-(NSArray<Question *> *)uncompletedQuestionUnderQuestion:(Question *)question {
    NSMutableArray<Question *> *questions = [NSMutableArray new];
    
    for (Question *innerQuestion in question.child) {
        if (!innerQuestion.completed) {
            [questions addObject:innerQuestion];
            [questions addObjectsFromArray:[self uncompletedQuestionUnderQuestion:innerQuestion]];
        }
    }
    
    return questions;
}

-(NSArray<Question *> *)terminatedUncompletedQuestion {
    return [[self flatUncompletedQuestion] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        Question *question = (Question *)evaluatedObject;
        for (Question *child in question.child) {
            if (!child.completed) {
                return false;
            }
        }
        return YES;
    }]];
}

-(NSArray<NSNumber*> *)pathOfQuestion:(Question *)question {
    NSMutableArray<NSNumber *> *pathes = [NSMutableArray new];
    
    Question *current = question;
    
    while (current) {
        if (current.parent) {
            [pathes insertObject:@([current.parent.child indexOfObject:current]) atIndex:0];
        } else {
            [pathes insertObject:@([self.questionnaire.que_li indexOfObject:current]) atIndex:0];
        }
        current = current.parent;
    }

    return pathes;
}

-(NSArray<Question *> *)linkOfQuestion:(Question *)question {
    NSMutableArray<Question *> *questiones = [NSMutableArray new];
    
    Question *current = question;
    
    while (current) {
        [questiones insertObject:current atIndex:0];
        current = current.parent;
    }

    return questiones;
}

- (NSArray<Question *> *)firstUncompletedLink {
    return [self linkOfQuestion:[[self terminatedUncompletedQuestion] firstObject]];
}

@end
