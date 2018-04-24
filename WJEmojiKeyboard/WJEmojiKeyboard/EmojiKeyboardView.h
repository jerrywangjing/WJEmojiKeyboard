//
//  EmojiKeyboardView.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/12/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmojiKeyboardView;

@protocol EmojiKeyboardViewDelegate <NSObject>


/**
 发送按钮的代理方法，必须实现。

 @param emojiKeyboard EmojiKeyboardView实例
 @param sendBtn 发送按钮
 */
- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickSendBtn:(UIButton *)sendBtn;

@optional


/**
 表情按钮的点击代理方法

 @param emojiKeyboard EmojiKeyboardView实例
 @param emojiBtn 所点击的表情按钮
 */
- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickEmojiBtn:(UIButton *)emojiBtn;

/**
 删除按钮点击代理

 @param emojiKeyboard EmojiKeyboardView实例
 @param deleteBtn 删除按钮
 */
- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickDeleteBtn:(UIButton *)deleteBtn;

/**
 底部表情包选择按钮

 @param emojiKeyboard EmojiKeyboardView实例
 @param emojiItem 表情包item
 */
- (void)wjEmojiKeyboard:(EmojiKeyboardView *)emojiKeyboard didClickEmojiItem:(UIButton *)emojiItem;

@end

@interface EmojiKeyboardView : UIView

@property (nonatomic,weak) UITextView * inputView;
@property (nonatomic,weak) UIButton * sendBtn;

@property (nonatomic,weak)id<EmojiKeyboardViewDelegate>delegate;


@end
