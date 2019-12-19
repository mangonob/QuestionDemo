//
//  CheckerNode.h
//  QuestionDemo
//
//  Created by G on 2019/12/19.
//  Copyright © 2019 G. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "Checker.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckerNode : ASControlNode

/// 内部包装的Checker类型的视图
@property (readonly) Checker *checker;

@end

NS_ASSUME_NONNULL_END
