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

-(EmojiKeyboardView *)emojiKeyboard{
    
    if (!_emojiKeyboard) {
        _emojiKeyboard = [[EmojiKeyboardView alloc] initWithFrame:CGRectMake(0, self.view.height-EmojiKeyboardH, self.view.width, EmojiKeyboardH)];
        _emojiKeyboard.delegate = self;
        
    }
    return _emojiKeyboard;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.view addSubview:self.emojiKeyboard];
}

#pragma mark - emojiKeyboard delegate

-(void)sendBtnDicClick:(UIButton *)btn{

    NSLog(@"发送消息");
}

-(void)emojiBtnDidClick:(UIButton *)btn{

    NSLog(@"点击表情-%ld",btn.tag);
}
-(void)emojiItemBtnClick:(UIButton *)btn{

    NSLog(@"选择表情-%ld",btn.tag);
}

-(void)deleteBtnDicClick:(UIButton *)btn{

    NSLog(@"删除表情");
}
@end
