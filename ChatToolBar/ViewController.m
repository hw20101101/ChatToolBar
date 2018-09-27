//
//  ViewController.m
//  ChatToolBar
//
//  Created by 快摇002 on 2018/9/26.
//  Copyright © 2018年 aiitec. All rights reserved.
//

#import "ViewController.h"
#import "DavidTextBar.h"
#import "DavidMediaView.h"
#import "DavidEmotionView.h"
#import "UIView+Extension.h"

typedef enum{
    InputViewShowNone,//文本
    InputViewShowAdd,//扩展
    InputViewShowEmotion,//表情
} InputViewStateType;//输入视图的类型

@interface ViewController ()<DavidTextBarDelegate, DavidMediaViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat emotionViewY;
@property (assign, nonatomic) CGRect keyBoardRect;
@property (strong, nonatomic) UITableView *tableView;

/**
 *  底部键盘工具条
 */
@property(nonatomic,strong) DavidTextBar *textBar;

/**
 扩展视图
 */
@property(nonatomic,strong) DavidMediaView *mediaView;

/**
 表情键盘视图
 */
@property(nonatomic,strong) DavidEmotionView *emotionView;

/**
 动画时间
 */
@property(nonatomic,assign) double duration;

/**
 是否已显示表情键盘/扩展键盘
 */
@property (assign, nonatomic) BOOL isShowEmotion;

/**
 是否已隐藏文本键盘/表情键盘/扩展键盘
 */
@property (assign, nonatomic) BOOL isHiddenKeyboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emotionViewY = IPHONE_X ? DavidTextBarHeight : 0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textBar];
    [self addObserver];
}

#pragma mark - 监听键盘
- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark  更新表情键盘的布局
-(void)changeEmotionViewFrame:(BOOL)selected
{
    self.isHiddenKeyboard = NO;

    if (selected){//显示表情键盘
        self.isShowEmotion = YES;
        self.emotionView.hidden = NO;
        [self messageViewAnimationWithMessageRect:self.emotionView.frame
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowEmotion];
    }else{//显示文本键盘
        self.isShowEmotion = NO;
        [self messageViewAnimationWithMessageRect:self.keyBoardRect
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowNone];
    }
}

#pragma mark  更新扩展键盘的布局
-(void)changeAddViewFrame:(BOOL)selected
{
    self.isHiddenKeyboard = NO;

    if (selected){//显示扩展键盘
        self.isShowEmotion = YES;
        self.mediaView.hidden = NO;
        [self messageViewAnimationWithMessageRect:self.mediaView.frame
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowAdd];
    }else{//显示文本键盘
        self.isShowEmotion = NO;
        [self messageViewAnimationWithMessageRect:self.keyBoardRect
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowNone];
    }
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect
                   withMessageInputViewRect:(CGRect)inputViewRect
                                andDuration:(double)duration
                                   andState:(InputViewStateType)state{

    [UIView animateWithDuration:duration animations:^{

        CGFloat tempY = 0;
        if (self.isHiddenKeyboard) {//即将隐藏键盘
            tempY = IPHONE_X ? 44 : 0;
        }

        CGFloat textBarY = CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect) - CGRectGetHeight(inputViewRect) - tempY;
        self.textBar.frame = CGRectMake(0.0f, textBarY, CGRectGetWidth(self.view.frame), CGRectGetHeight(inputViewRect));

        switch (state) {
            case InputViewShowNone:{
                self.mediaView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.mediaView.frame));
                self.emotionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.emotionView.frame));
            }

                break;

            case InputViewShowAdd:{
                self.mediaView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect), CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));
                self.emotionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.emotionView.frame));
            }

                break;

            case InputViewShowEmotion:{
                self.emotionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect), CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));
                self.mediaView.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.mediaView.frame));

            }

                break;

            default:
                break;
        }
    }];

    [self setTableViewInsetsWithBottomValue:self.view.height - self.textBar.y - DavidTextBarHeight];
}

#pragma mark - keyBoardWillShow
-(void)keyBoardWillShow:(NSNotification*)notification
{
    self.isHiddenKeyboard = NO;
    NSDictionary *infoDic = notification.userInfo;
    //取出动画的时间
    self.duration = [infoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyBoardRect = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                     withMessageInputViewRect:self.textBar.frame
                                  andDuration:0.25
                                     andState:InputViewShowNone];
}

-(void)keyBoardWillHide:(NSNotification*)notification
{
    NSDictionary *infoDic = notification.userInfo;
    //取出动画的时间
    self.duration  = [infoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyBoardRect  = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [self closeKeyboard];
}

#pragma mark - config ui
- (UITableView *)tableView{

    CGFloat height = 0;
    if (IPHONE_X) {
        height = HEIGHT - DavidTextBarHeight - TOPBAR_HEIGHT - 44;
    } else {
        height = HEIGHT - DavidTextBarHeight - TOPBAR_HEIGHT;
    }

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.allowsSelection = NO;
        _tableView.frame = CGRectMake(0, TOPBAR_HEIGHT, WIDTH, height);
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
        [_tableView addGestureRecognizer:tapRecognizer];
    }
    return _tableView;
}

- (DavidTextBar *)textBar
{
    __weak typeof(self)weakSelf = self;
    if (!_textBar) {
        _textBar = [[DavidTextBar alloc] initWithFrame:CGRectMake(0, weakSelf.view.height - weakSelf.emotionViewY - DavidTextBarHeight, WIDTH, DavidTextBarHeight)];
        _textBar.delegate = weakSelf;
    }
    return _textBar;
}

-(DavidMediaView*)mediaView
{
    if (!_mediaView) {
        _mediaView  = [[DavidMediaView alloc] initWithFrame:CGRectMake(0, self.view.height - self.emotionViewY, WIDTH, ExtendViewHeight)];
        _mediaView.backgroundColor = [UIColor whiteColor];
        _mediaView.delegate = self;
        _mediaView.hidden = YES;
        [self.view addSubview:_mediaView];
    }
    return _mediaView;
}

-(DavidEmotionView*)emotionView
{
    if (!_emotionView) {
        _emotionView  = [[DavidEmotionView alloc] initWithFrame:CGRectMake(0, self.view.height - self.emotionViewY, WIDTH, ExtendViewHeight)];
        _emotionView.backgroundColor = [UIColor whiteColor];
        _emotionView.hidden = YES;
        [self.view addSubview:_emotionView];
    }
    return _emotionView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cellForRowAtIndexPath - %ld", indexPath.row];
    return cell;
}

#pragma mark - DavidTextBarDelegate
-(void)textBar:(DavidTextBar *)textBar andButtonType:(DavidTextBarButtonType)buttonType andSelected:(BOOL)selected
{
    switch (buttonType) {
        case DavidTextBarEmotionButton:{
            [self changeEmotionViewFrame:selected];
        }
            break;

        case DavidTextBarExtendButton:{
            [self changeAddViewFrame:selected];
        }
            break;

        default:

            break;
    }
}

-(void)textbarTextViewDidBeginEnditing:(DavidTextBar *)texBar
{
    self.isShowEmotion = NO;
}

-(void)mediaView:(DavidMediaView *)mediaView didClickAtButton:(DavidMediaViewButtonType)button
{
    switch (button) {
        case DavidMediaViewPhotoButton://点击照片
            break;

        case DavidMediaViewOrderButton://点击订单
            break;

        default:
            break;
    }
}

#pragma mark - update tableView
/**
 *  根据bottom的数值配置消息列表的内部布局变化
 *  @param bottom 底部的空缺高度
 */
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {

    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    [self scrollToBottomAnimated:YES];
}
/**
 *  根据底部高度获取UIEdgeInsets常量
 *  @param bottom 底部高度
 *  @return 返回UIEdgeInsets常量
 */
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {

    UIEdgeInsets insets = UIEdgeInsetsZero;
    //    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    //        insets.top = self.topLayoutGuide.length;
    //    }
    insets.bottom = bottom;
    return insets;
}

- (void)scrollToBottomAnimated:(BOOL)animated {

    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - 屏幕点击事件
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    self.isShowEmotion = NO;
    [self closeKeyboard];
}

#pragma mark   关闭键盘工具条
- (void)closeKeyboard {

    [self.view endEditing:YES];

    if (self.isShowEmotion || self.isHiddenKeyboard) {
        return;
    }

    [self.textBar resetButtonStatus];
    self.isHiddenKeyboard = YES;

    //还原表情键盘的位置
    CGFloat tempY = IPHONE_X ? DavidTextBarHeight : 0;
    CGFloat emotionViewY = self.view.height - tempY;
    CGRect frame = self.emotionView.frame;
    frame.origin.y = emotionViewY;
    self.emotionView.frame = frame;

    //还原扩展键盘的位置
    CGRect frame2 = self.mediaView.frame;
    frame2.origin.y = emotionViewY;
    self.mediaView.frame = frame2;

    [self messageViewAnimationWithMessageRect:CGRectMake(0, 0, 0, 0)
                     withMessageInputViewRect:self.textBar.frame
                                  andDuration:0.25
                                     andState:InputViewShowNone];

    CGFloat bottom = IPHONE_X ? DavidTextBarHeight : 0;
    [self setTableViewInsetsWithBottomValue:bottom];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
