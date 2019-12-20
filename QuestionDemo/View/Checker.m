//
//  Checker.m
//  QuestionDemo
//
//  Created by G on 2019/12/19.
//  Copyright © 2019 G. All rights reserved.
//

#import "Checker.h"

@implementation Checker

-(instancetype)init {
    if (self = [super init]) {
        self.checkerColor = UIColor.blueColor;
        self.borderWidth = 1;
        self.backgroundColor = UIColor.clearColor;
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

-(void)setBorderWidth:(BOOL)borderWidth {
    _borderWidth = borderWidth;
    [self  setNeedsDisplay];
}

-(void)setCheckerStyle:(CheckerStyle)checkerStyle {
    _checkerStyle = checkerStyle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    switch (self.checkerStyle) {
        case CheckerStyleRadio:
            [self drawRadio:rect];
            break;
        case CheckerStyleChecker:
            [self drawChecker:rect];
            break;
    }
}

/// 绘制单选按钮
-(void)drawRadio:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextScaleCTM(context, self.bounds.size.width / 2, self.bounds.size.height / 2);
        CGContextTranslateCTM(context, 1, 1);

        CGFloat scaleRate = 2 / self.bounds.size.width;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-1, -1, 2, 2)];
        
        CGFloat border = self.borderWidth * scaleRate * 2;
        [path addClip];
        path.lineWidth = border;
        [self.checkerColor setStroke];
        [path stroke];
        
        if (self.selected) {
            CGContextSaveGState(context);
            {
                CGFloat scale = 1 - (self.borderWidth + 2) * scaleRate;
                CGContextScaleCTM(context, scale, scale) ;
                [self.checkerColor setFill];
                [path fill];
            }
            CGContextRestoreGState(context);
        }
    }
    CGContextRestoreGState(context);
}

/// 绘制多选按钮
-(void)drawChecker:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextScaleCTM(context, self.bounds.size.width / 2, self.bounds.size.height / 2);
        CGContextTranslateCTM(context, 1, 1);
        
        CGFloat scaleRate = 2 / self.bounds.size.width;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-1, -1, 2, 2) cornerRadius:scaleRate * 3];

        CGFloat border = self.borderWidth * scaleRate * 2;
        [path addClip];
        path.lineWidth = border;
        [self.checkerColor setStroke];
        [path stroke];
        
        if (self.selected) {
            CGContextSaveGState(context);
            {
                CGFloat scale = 1 - (self.borderWidth + 2) * scaleRate;
                CGContextScaleCTM(context, scale, scale) ;
                [self.checkerColor setFill];
                [path fill];
            }
            CGContextRestoreGState(context);
        }
    }
    CGContextRestoreGState(context);
}

@end
