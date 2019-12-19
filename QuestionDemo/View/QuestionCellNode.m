//
//  QuestionCellNode.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "QuestionCellNode.h"

@interface QuestionCellNode()
@property (strong, nonatomic) ASTextNode *titleNode;
@property (strong, nonatomic) ASEditableTextNode *textNode;
@property (strong, nonatomic) CheckerNode *checkerNode;
@end

@implementation QuestionCellNode

-(NSString *)text {
    return self.textNode.attributedText.string;
}

-(void)setText:(NSString *)text {
    self.textNode.attributedText =
    [[NSAttributedString alloc] initWithString:text attributes:self.textNode.typingAttributes];
}

-(ASTextNode *)titleNode {
    if (!_titleNode) {
        _titleNode = [ASTextNode new];
    }
    
    return _titleNode;
}

-(ASEditableTextNode *)textNode {
    if (!_textNode) {
        _textNode = [ASEditableTextNode new];
        _textNode.attributedPlaceholderText = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{
            NSForegroundColorAttributeName: UIColor.lightGrayColor,
            NSFontAttributeName: [UIFont systemFontOfSize:16],
        }];
        
        _textNode.typingAttributes = @{
            NSForegroundColorAttributeName: UIColor.darkGrayColor,
            NSFontAttributeName: [UIFont systemFontOfSize:16],
        };
        
        _textNode.cornerRadius = 3;
        _textNode.borderColor = UIColor.lightGrayColor.CGColor;
        _textNode.borderWidth = 1;
        
        _textNode.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4);
    }
    
    return _textNode;
}

-(CheckerNode *)checkerNode {
    if (!_checkerNode) {
        _checkerNode = [CheckerNode new];
    }
    
    return _checkerNode;
}

-(BOOL)isChecked {
    return self.checkerNode.checker.selected;
}

-(void)setChecked:(BOOL)checked {
    self.checkerNode.checker.selected = checked;
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

-(void)setTitle:(NSString *)title {
    [self.titleNode setAttributedText:[[NSAttributedString alloc] initWithString:title attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16],
    }]];
}

- (instancetype)init
{
    if ([super init]) {
        self.automaticallyManagesSubnodes = true;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 默认隐藏文本输入框
        self.textHidden = true;
        self.checkerHidden = true;
    }
    return self;
}

-(instancetype)accept:(id<QuestionCellNodeVisitor>)visitor {
    [visitor visit:self];
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    CGFloat indentUnit = 16;
    
    ASStackLayoutSpec *contentStack =
    [ASStackLayoutSpec
     stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
     spacing:8 justifyContent:ASStackLayoutJustifyContentSpaceBetween
     alignItems:ASStackLayoutAlignItemsStretch
     children:@[]];
    
    if (self.checkerHidden) {
        contentStack.child = self.titleNode;
        self.titleNode.style.flexGrow = 0;
        self.titleNode.style.flexShrink = 0;
    } else {
        self.checkerNode.style.preferredSize = CGSizeMake(18, 18);
        self.titleNode.style.flexGrow = 1;
        self.titleNode.style.flexShrink = 1;

        ASStackLayoutSpec *stack =
        [ASStackLayoutSpec
         stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
         spacing:16
         justifyContent:ASStackLayoutJustifyContentSpaceBetween
         alignItems:ASStackLayoutAlignItemsCenter
         children:@[
             self.checkerNode,
             self.titleNode,
         ]];
        
        contentStack.child = stack;
    }
    
    if (!self.textHidden) {
        self.textNode.style.height = ASDimensionMakeWithPoints(100);
        contentStack.children = [contentStack.children arrayByAddingObject:self.textNode];
    }

    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, indentUnit * self.leadingIndentLevel, 0, indentUnit * self.trailingIndentLevel)
            child: [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 16, 8, 16)
                    child:contentStack]];
}

@end
