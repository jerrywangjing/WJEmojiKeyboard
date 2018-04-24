# WJEmojiKeyboard  

### 简介

**WJEmojiKeyboard**一个实现自动添加表情按钮，自动添加多页scorllView 滚动视图的表情键盘，支持表情选择切换，表情发送、表情删除等功能。适用于快速集成即时通讯表情选择功能。

### 安装

直接拖动Demo中`WJEmojiKeyboard`文件夹中的内容到Xcode相应的文件夹即可。

### 使用

```objective-c
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, self.view.height-EmojiKeyboardH, self.view.width, EmojiKeyboardH);
    _emojiKeyboard = [[EmojiKeyboardView alloc] initWithFrame:frame];
    _emojiKeyboard.delegate = self;
    
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
```

### 功能图示
![emojiboard](https://github.com/jerrywangjing/WJEmojiKeyboard/raw/master/screenShots/emojiboard.gif)

### 交流学习/欢迎issues

- 邮箱：wangjing268@163.com
- QQ:495388884
- [简书](http://www.jianshu.com/u/187fc23bc390)
