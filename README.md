# WJEmojiKeyboard  

### 简介

**WJEmojiKeyboard**一个实现自动添加表情按钮，自动添加多页scorllView 滚动视图的表情键盘，支持表情选择切换，表情发送、表情删除等功能。适用于快速集成即时通讯表情选择功能。

### 安装

直接拖动Demo中`WJEmojiKeyboard`文件夹中的内容到Xcode相应的文件夹即可。

### 使用

```objective-c
CGRect frame = CGRectMake(0, SCREEN_HEIGHT-ViewH, SCREEN_WIDTH, ViewH);

_scrollBtnView = [[WJScrollButtonView alloc] initWithFrame:frame dataSource:self.dataSource];
    
_scrollBtnView.LineSpacing = 10;		// 设置行间距
_scrollBtnView.columnsSpacing = 10;		// 设置列间距
    
_scrollBtnView.didClickBtn = ^(UIButton *btn) {	// 回调block
    NSLog(@"click:%ld",btn.tag);
};
    
[self.view addSubview:_scrollBtnView];
```

### 功能图示
![emojiboard](https://github.com/jerrywangjing/WJEmojiKeyboard/raw/master/screenShots/emojiboard.gif)

### 交流学习/欢迎issues

- 邮箱：wangjing268@163.com
- QQ:495388884
- [简书](http://www.jianshu.com/u/187fc23bc390)
