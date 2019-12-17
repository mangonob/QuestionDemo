//
//  QuestionCellNode.h
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QuestionCellNode;

@protocol QuestionCellNodeVisitor
-(void)visit:(QuestionCellNode *)cell;
@end

@interface QuestionCellNode : ASCellNode

@property (assign, nonatomic) CGFloat indentLevel;
@property (assign, nonatomic) CGFloat leadingIndentLevel;
@property (assign, nonatomic) CGFloat trailingIndentLevel;

-(void)setText:(NSString *)text;

-(instancetype)accept:(id <QuestionCellNodeVisitor>)visitor;

@end

NS_ASSUME_NONNULL_END
