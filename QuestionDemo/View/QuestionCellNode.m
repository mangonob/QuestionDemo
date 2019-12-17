//
//  QuestionCellNode.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "QuestionCellNode.h"

@interface QuestionCellNode()
@property (strong, nonatomic) ASTextNode *textNode;
@end

@implementation QuestionCellNode

-(ASTextNode *)textNode {
    if (!_textNode) {
        _textNode = [ASTextNode new];
    }
    
    return _textNode;
}

-(void)setIndentLevel:(CGFloat)indentLevel {
    _indentLevel = indentLevel;
    _leadingIndentLevel = indentLevel;
    _trailingIndentLevel = indentLevel;

    [self setNeedsLayout];
}

-(void)setLeadingIndentLevel:(CGFloat)leadingIndentLevel {
    _leadingIndentLevel = leadingIndentLevel;
    
    [self setNeedsLayout];
}

-(void)setTrailingIndentLevel:(CGFloat)trailingIndentLevel {
    _trailingIndentLevel = trailingIndentLevel;
    
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text {
    [self.textNode setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:@{
    }]];
}

- (instancetype)init
{
    if ([super init]) {
        self.automaticallyManagesSubnodes = true;
    }
    return self;
}

-(instancetype)accept:(id<QuestionCellNodeVisitor>)visitor {
    [visitor visit:self];
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    CGFloat indentUnit = 16;
    
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, indentUnit * self.leadingIndentLevel, 0, indentUnit * self.trailingIndentLevel)
            child: [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                    child:self.textNode]];
}

@end
