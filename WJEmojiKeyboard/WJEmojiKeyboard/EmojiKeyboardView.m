//
//  EmojiKeyboardView.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/12/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "EmojiKeyboardView.h"
#import "UIView+WJExtension.h"

#define BGColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define WIDTH_RATE (SCREEN_WIDTH/375)           // 屏幕宽度系数（以4.7英寸为基准）
#define HEIGHT_RATE (SCREEN_HEIGHT/667)

//#define WidthGap 18                             // 可调节布局间距
//#define HeightGap 20

#define WJ_DEFAULT_BTN_WH 30*WIDTH_RATE                 // 默认的按钮宽高

static const CGFloat WJ_DEFAULT_HEIGHT = 187.5;           // 默认的view高度
static const CGFloat WJ_PAGE_CONTROL_HEIGHT = 15;         // pageControl 高度
static const CGFloat WJ_TOOLBAR_HEIGHT = 37.5;            // toolbar 高度
static const CGFloat WJ_TOOLBTN_COUNT = 7;
static const NSUInteger WJ_NUMBEROFSINGLE_PAGE = 21;     // 一个页面中放置的按钮数
static const NSUInteger MAX_COL = 7;                    // 最大的列数
static const NSUInteger MAX_ROW = 3;                    // 最大的行数

@interface EmojiKeyboardView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * contentScrollView;
@property (nonatomic,strong) UIPageControl * pageControl;

@property (nonatomic,weak) UIView * toolbar;
@property (nonatomic,weak) UITextView *inputView;
@property (nonatomic,weak) UIButton *sendBtn;

@property (nonatomic,strong) NSMutableArray *btns;       // 所有的btn对象

@property (nonatomic,strong) NSArray *emojiTitles;      // 表情对应的文字表述，比如：[微笑]
@property (nonatomic,assign) NSInteger pageCount;       // 分页数

@end

@implementation EmojiKeyboardView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        
        [self loadData];
        [self setupSubviews];
    }
    return self;
}

- (void)loadData{
    
    _LineSpacing = 20;
    _columnsSpacing = 18;
    
    // 表情解析文字
    NSString *emojiTitelsPath = [[NSBundle mainBundle] pathForResource:@"emojiDataArr" ofType:@"plist"];
    _emojiTitles = [NSArray arrayWithContentsOfFile:emojiTitelsPath];
 
    // 分页数
    
    _pageCount = _emojiTitles.count / WJ_NUMBEROFSINGLE_PAGE;
    if ((_emojiTitles.count % WJ_NUMBEROFSINGLE_PAGE) > 0) {
        _pageCount += 1;
    }
}

-(void)setupSubviews{
    
    // scroll view
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width,WJ_DEFAULT_HEIGHT)];
    _contentScrollView.delegate = self;
    _contentScrollView.backgroundColor = BGColor;
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.pageCount, WJ_DEFAULT_HEIGHT);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_contentScrollView];
    
    // page control
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, WJ_DEFAULT_HEIGHT-WJ_PAGE_CONTROL_HEIGHT, 0, 0)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.numberOfPages = self.pageCount;

    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
    
    
    // tool bar
    
    UIView * toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, WJ_DEFAULT_HEIGHT, self.width, WJ_TOOLBAR_HEIGHT)];
    _toolbar = toolbar;
    _toolbar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_toolbar];
    
    CGFloat btnW = self.width/WJ_TOOLBTN_COUNT;
    CGFloat btnH = WJ_TOOLBAR_HEIGHT;
    
    for (int i = 0; i < WJ_TOOLBTN_COUNT; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(btnW*i, 0, btnW,btnH);
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:btn];
        
        // 发送按钮
        if (i == WJ_TOOLBTN_COUNT-1) {
            
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage imageNamed:@"submit_but_bg_nor"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"voice_press_bg"] forState:UIControlStateDisabled];
            
            self.sendBtn = btn;
            
        }else if(i == 0){
        
            [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"voice_press_bg"] forState:UIControlStateNormal];
        }
    }
    
    // add emoji btns
    
    for (NSInteger i = 0; i < _pageCount; i++) {
        [self addBtnsWithPageNum:i];
    }
}


// 循环添加按钮
-(void)addBtnsWithPageNum:(NSInteger)pageNum{
    
    
    // 添加按钮
    NSInteger btnCount = self.emojiTitles.count;
    CGFloat btnW = WJ_DEFAULT_BTN_WH;
    CGFloat btnH = btnW;
    CGFloat widthMargin = (self.width - (MAX_COL*btnW + (MAX_COL-1) * _columnsSpacing))/2;
    CGFloat heightMargin = (WJ_DEFAULT_HEIGHT - (MAX_ROW*btnH + (MAX_ROW-1) * _LineSpacing))/2;

    NSInteger count = btnCount - (pageNum * WJ_NUMBEROFSINGLE_PAGE);
    NSInteger indexCount;
    
    if (count > 0 && count <= WJ_NUMBEROFSINGLE_PAGE) {
        
        indexCount = count;
        
    }else if(count > WJ_NUMBEROFSINGLE_PAGE){
        
        indexCount = WJ_NUMBEROFSINGLE_PAGE;
    }else{
        
        return;
    }
    
    for (int i = 0; i < indexCount; i++) {
        
        UIButton  * btn = [[UIButton alloc] init];
        
        int col = i % MAX_COL;
        int row = i / MAX_COL;
        
        //注意：由于表情中有删除按钮，取表情按钮时需要减个页码号才正确
        NSInteger index = i + (pageNum * WJ_NUMBEROFSINGLE_PAGE - pageNum);
        
        // 设置图片frame
        
        btn.x = col * (btnW + _columnsSpacing) + widthMargin + pageNum * self.width;
        btn.y = row * (btnH + _LineSpacing) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.tag = index;
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentScrollView addSubview:btn];
        [self.btns addObject:btn];
        
        // 主线程处理UI
        
        if (i== WJ_NUMBEROFSINGLE_PAGE-1) {
            [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
        }else{
            
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"[%ld]",index+1]] forState:UIControlStateNormal];
        }
    }
    
    // 如果单页按钮数量少于最大容纳数时，任然需要添加删除按钮
    
    if (indexCount <= (WJ_NUMBEROFSINGLE_PAGE-1)) {
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.x = (MAX_COL-1) * (btnW + _columnsSpacing) + widthMargin + pageNum * self.width;
        btn.y = (MAX_ROW-1) * (btnH + _LineSpacing) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        
        btn.tag = ((WJ_NUMBEROFSINGLE_PAGE-1) + pageNum * (WJ_NUMBEROFSINGLE_PAGE-1));
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentScrollView addSubview:btn];
        [self.btns addObject:btn];
            // 主线程处理UI
        [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
    }
}

#pragma mark - actions

-(void)emojiBtnClick:(UIButton *)btn{
    
    
    if (btn.tag == ((WJ_NUMBEROFSINGLE_PAGE-1) + _pageControl.currentPage*(WJ_NUMBEROFSINGLE_PAGE-1))) { // 减一是为了排除删除按钮
        //NSLog(@"删除:%ld",btn.tag);
        [self.inputView deleteBackward];

        if ([self.delegate respondsToSelector:@selector(wjEmojiKeyboard:didClickDeleteBtn:)]) {
            [self.delegate wjEmojiKeyboard:self didClickDeleteBtn:btn];
        }
    }else{
    
        [self appendEmojiToInputViewWithTag:btn.tag];
        
        if ([self.delegate respondsToSelector:@selector(wjEmojiKeyboard:didClickEmojiBtn:)]) {
            [self.delegate wjEmojiKeyboard:self didClickEmojiBtn:btn];
        }
    }
     
}

-(void)toolbarBtnClick:(UIButton * )btn{

    // 处理点击背景高亮(表情包大于1后使用)
//    if (_lastBtn.selected) {
//        _lastBtn.selected = NO;
//    }
//    btn.selected = YES;
//    _lastBtn = btn;
    
    
    // 处理点击事件
    if (btn.tag == WJ_TOOLBTN_COUNT-1) {
        
        //NSLog(@"发送消息");
        if ([self.delegate respondsToSelector:@selector(wjEmojiKeyboard:didClickSendBtn:)]) {
            [self.delegate wjEmojiKeyboard:self didClickSendBtn:btn];
        }
        
    }else{
    
        if ([self.delegate respondsToSelector:@selector(wjEmojiKeyboard:didClickEmojiItem:)]) {
            [self.delegate wjEmojiKeyboard:self didClickEmojiItem:btn];
        }
        //NSLog(@"表情包:%ld",btn.tag);
    }
}

// 映射表情文字

-(void)appendEmojiToInputViewWithTag:(NSInteger )tag{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotionTags.plist" ofType:nil];
    NSArray * emojiArr = [NSArray arrayWithContentsOfFile:path];
    
    //NSAttributedString * attributStr  = [[NSAttributedString alloc] initWithString:emojiArr[tag]];
    self.inputView.text = [self.inputView.text stringByAppendingString:emojiArr[tag]];
    
    NSLog(@"inputed text:%@",self.inputView.text);
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger correntCount = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageControl.currentPage = correntCount;
}


#pragma mark - getter

- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

#pragma mark - setter

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.contentScrollView.backgroundColor = backgroundColor;
}

- (void)setLineSpacing:(CGFloat)LineSpacing{
    _LineSpacing = LineSpacing;
    [self updateBtnMargin];
}
- (void)setColumnsSpacing:(CGFloat)columnsSpacing{
    _columnsSpacing = columnsSpacing;
    [self updateBtnMargin];
}

#pragma mark - private

- (void)updateBtnMargin{
    
    CGFloat btnW = WJ_DEFAULT_BTN_WH;
    CGFloat btnH = btnW;
    
    CGFloat leftRightMargin = (self.width - (MAX_COL*btnW + (MAX_COL-1) * _columnsSpacing))/2;
    CGFloat topBottomMargin = (WJ_DEFAULT_HEIGHT - (MAX_ROW*btnH + (MAX_ROW-1) * _LineSpacing))/2;
    
    for (NSInteger i = 0; i < self.btns.count; i++) {
        
        UIButton *btn = self.btns[i];
        
        NSInteger page =  i / WJ_NUMBEROFSINGLE_PAGE;
        
        NSInteger col = i % MAX_COL;
        NSInteger row = (i-page*WJ_NUMBEROFSINGLE_PAGE) / MAX_COL;
        
        CGFloat btnX = col * (btnW + _columnsSpacing) + leftRightMargin + page * self.width;
        CGFloat btnY = row * (btnH + _LineSpacing) + topBottomMargin;
        
//        btn.x = (MAX_COL-1) * (btnW + _columnsSpacing) + widthMargin + pageNum * self.width;
//        btn.y = (MAX_ROW-1) * (btnH + _LineSpacing) + heightMargin;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}
@end
