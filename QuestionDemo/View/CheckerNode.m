//
//  CheckerNode.m
//  QuestionDemo
//
//  Created by G on 2019/12/19.
//  Copyright © 2019 G. All rights reserved.
//

#import "CheckerNode.h"

@implementation CheckerNode

-(Checker *)checker {
    return (Checker *)self.view;
}

-(instancetype)init {
    if (self = [super init]) {
        [self setViewBlock:^UIView * _Nonnull{
            return [Checker new];
        }];
    }
    
    return self;
}

@end
