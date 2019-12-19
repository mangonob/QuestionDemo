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
        self.tintColor = UIColor.blueColor;
        self.borderWidth = 1;
        self.backgroundColor = UIColor.clearColor;
    }
    
    return self;
}

-(void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

-(void)setBorderWidth:(BOOL)borderWidth {
    _borderWidth = borderWidth;
    [self  setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawRadio:rect];
}

-(void)drawRadio:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextScaleCTM(context, self.bounds.size.width, self.bounds.size.height);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 1, 1)];
        
        if (self.selected) {
            [self.tintColor setFill];
            [path fill];
        } else {
            CGFloat border = self.borderWidth / self.bounds.size.width * 2;
            [path addClip];
            path.lineWidth = border;
            [self.tintColor setStroke];
            [path stroke];
        }
    }
    CGContextRestoreGState(context);
}

-(void)drawChecker:(CGRect)rect {
}

@end
