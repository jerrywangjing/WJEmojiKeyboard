//
//  ViewController.m
//  WJEmojiKeyboard
//
//  Created by JerryWang on 2016/12/22.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "ViewController.h"
#import "EmojiKeyboardView.h"
#import "UIView+WJExtension.h"

#define EmojiKeyboardH 225

@interface ViewController()<EmojiKeyboardViewDelegate>

@property (nonatomic,strong)EmojiKeyboardView * emojiKeyboard;

@end

@implementation ViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    CGRect frame = CGRectMake(0, self.view.height-EmojiKeyboardH, self.view.width, EmojiKeyboardH);
    _emojiKeyboard = [[EmojiKeyboardView alloc] initWithFrame:frame];
    _emojiKeyboard.delegate = self;
//    _emojiKeyboard.LineSpacing = 15;
//    _emojiKeyboard.columnsSpacing = 13;
    [self.view addSubview:_emojiKeyboard];
}

#pragma mark - emojiKeyboard delegate

- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickSendBtn:(UIButton *)sendBtn{
    NSLog(@"发送消息");
}

- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickEmojiBtn:(UIButton *)emojiBtn{
    NSLog(@"点击表情-%ld",emojiBtn.tag);
}

- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickDeleteBtn:(UIButton *)deleteBtn{
    NSLog(@"删除表情");
}

- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickEmojiItem:(UIButton *)emojiItem{
    NSLog(@"选择表情包-%ld",emojiItem.tag);
}
@end
