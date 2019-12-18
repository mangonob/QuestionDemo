//
//  QuestionController.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "QuestionController.h"
#import "Question.h"
#import "QuestionCellNode.h"

@interface QuestionController () <ASTableDelegate, ASTableDataSource>
@property (strong, nonatomic) ASTableNode *tableNode;
@property (strong, nonatomic) ASButtonNode *prevButtonNode;
@property (strong, nonatomic) ASButtonNode *nextButtonNode;
@property (strong, nonatomic) ASButtonNode *confirmButtonNode;
@end

@implementation QuestionController

-(void)setQuestion:(Question *)question {
    _question = question;
    self.prevButtonNode.enabled = !question.head;
    self.nextButtonNode.enabled = !question.tail;
}

-(instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        self.node.automaticallyManagesSubnodes = true;
        
        __weak QuestionController *weakSelf = self;
        [self.node setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            return [weakSelf node:node layoutSpecThatFits:constrainedSize];
        }];
    }
    
    return self;
}

-(instancetype)initWithQuestion:(Question *)question {
    if (self = [self init]) {
        self.question = question;
    }
    
    return self;
}

- (ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _tableNode;
}

-(ASButtonNode *)prevButtonNode {
    if (!_prevButtonNode) {
        _prevButtonNode = [ASButtonNode new];
        [_prevButtonNode setTitle:@"上一题" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.blackColor forState:UIControlStateNormal];
        [_prevButtonNode setTitle:@"上一题" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [_prevButtonNode addTarget:self action:@selector(prevAction:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    
    return _prevButtonNode;
}

-(ASButtonNode *)nextButtonNode {
    if (!_nextButtonNode) {
        _nextButtonNode = [ASButtonNode new];
        [_nextButtonNode setTitle:@"下一题" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.blackColor forState:UIControlStateNormal];
        [_nextButtonNode setTitle:@"下一题" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [_nextButtonNode addTarget:self action:@selector(nextAction:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    
    return _nextButtonNode;
}

-(ASButtonNode *)confirmButtonNode {
    if (!_confirmButtonNode) {
        _confirmButtonNode = [ASButtonNode new];
        [_confirmButtonNode setTitle:@"确认提交" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.blackColor forState:UIControlStateNormal];
        [_confirmButtonNode setTitle:@"确认提交" withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] withColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        [_confirmButtonNode addTarget:self action:@selector(confirmAction:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    
    return _confirmButtonNode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.node.backgroundColor = UIColor.whiteColor;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(ASLayoutSpec *)node:(ASDisplayNode *)node layoutSpecThatFits:(ASSizeRange)size {
    self.tableNode.style.flexGrow = 1;
    
    ASStackLayoutSpec *buttonStack =
    [ASStackLayoutSpec
     stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
     spacing:16
     justifyContent:ASStackLayoutJustifyContentSpaceBetween
     alignItems:ASStackLayoutAlignItemsStretch
     children: @[]];
    
    if (self.question.tail) {
        buttonStack.child = self.confirmButtonNode;
        buttonStack.justifyContent = ASStackLayoutJustifyContentCenter;
    } else {
        self.prevButtonNode.style.flexGrow = 1;
        self.nextButtonNode.style.flexGrow = 1;
        self.prevButtonNode.style.flexShrink = 1;
        self.nextButtonNode.style.flexShrink = 1;
        buttonStack.children = @[self.prevButtonNode, self.nextButtonNode];
    }

    return
    [ASInsetLayoutSpec
     insetLayoutSpecWithInsets:node.safeAreaInsets
     child: [ASStackLayoutSpec
             stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
             spacing:0
             justifyContent:ASStackLayoutJustifyContentSpaceBetween
             alignItems:ASStackLayoutAlignItemsStretch
             children:@[
                 self.tableNode,
                 [ASInsetLayoutSpec
                  insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 16, 40, 16)
                  child:buttonStack],
             ]]
     ];
}

-(NSArray<Question *> *)questions {
    if (self.question) {
        NSMutableArray<Question *> *questions = [[NSMutableArray alloc] initWithObjects:self.question, nil];
        if (self.question.descendants) {
            [questions addObjectsFromArray:self.question.descendants];
        }
        return questions;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

-(NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [[self questions] count];
}

-(void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:false];
    Question *question = [[self questions] objectAtIndex:indexPath.row];
    NSLog(@"选中 %@", question);
    if ([question interacte]) {
        [tableNode reloadData];
    }
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
    QuestionCellNode *cellNode;
    if ([oldCellNode isMemberOfClass:[QuestionCellNode class]]) {
        cellNode = oldCellNode;
    } else {
        cellNode = [QuestionCellNode new];
    }
    return [cellNode accept:[self questions][indexPath.row]];
}

#pragma mark - Action
-(void)prevAction:(id)sender {
    [self.delegate questionController:self performAction:QuestionControllerActionPrev];
}

-(void)nextAction:(id)sender {
    [self.delegate questionController:self performAction:QuestionControllerActionNext];
}

-(void)confirmAction:(id)sender {
    [self.delegate questionController:self performAction:QuestionControllerActionConfirm];
}

@end
