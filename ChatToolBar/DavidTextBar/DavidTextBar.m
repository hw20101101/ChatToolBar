//
//  DavidTextBar.m
//  KeyboradDemn 客服聊天界面的键盘工具条
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidTextBar.h"
#import "UIView+Extension.h"
#import "UITextView+WZB.h"

#define ButtonWH 30
#define ButtonMargin 10

@interface DavidTextBar()<UITextViewDelegate>

/**
 是否已切换为表情键盘
 */
@property (assign, nonatomic) BOOL isEmotionKeyboard;


/**
 是否已切换为扩展键盘
 */
@property (assign, nonatomic) BOOL isExtendKeyboard;


/**
 转人工按钮
 */
@property (strong, nonatomic) UIButton *artificialButton;

/**
 扩展键盘按钮
 */
@property(nonatomic,strong) UIButton *extendButton;

/**
 表情键盘按钮
 */
@property(nonatomic,strong) UIButton *emotionButton;

/**
 文本输入框
 */
@property(nonatomic,strong) UITextView *textView;

@end

@implementation DavidTextBar


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f] CGColor];
        [self addSubview:self.artificialButton];
        [self addSubview:self.textView];
        [self addObserver];
    }
    return self;
}

//文本输入框
- (UITextView *)textView{

    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.textColor = [UIColor blackColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];         
        _textView.wzb_placeholder = @"请输入...";

        //未输入文本时，禁止点击 return 按钮
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.frame = CGRectMake(CGRectGetMaxX(self.artificialButton.frame) + ButtonMargin,
                                     self.height / 2 - 40 / 2,
                                     self.width - 2 * ButtonMargin - ButtonWH,
                                     40);
    }
    return _textView;
}

//转人工按钮
- (UIButton *)artificialButton{

    if (!_artificialButton) {
        _artificialButton = [[UIButton alloc] init];
        _artificialButton.tag = DavidTextBarArtificialButton;
        _artificialButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _artificialButton.frame = CGRectMake(14, self.height / 2 - ButtonWH / 2, ButtonWH, ButtonWH);
        [_artificialButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_artificialButton setBackgroundColor:[UIColor yellowColor]];
        //        [_artificialButton setBackgroundImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        //        [_artificialButton setBackgroundImage:[UIImage imageNamed:@"add_button_selected"] forState:UIControlStateSelected];
    }
    return _artificialButton;
}

//扩展键盘按钮
- (UIButton *)extendButton{

    if (!_extendButton) {
        _extendButton = [[UIButton alloc] init];
        _extendButton.tag = DavidTextBarExtendButton;
        _extendButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _extendButton.frame = CGRectMake(CGRectGetMaxX(self.emotionButton.frame) + ButtonMargin,  self.height / 2 - ButtonWH / 2, ButtonWH, ButtonWH);
        [_extendButton setBackgroundColor:[UIColor redColor]];
        [_extendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [_extendButton setBackgroundImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        //        [_extendButton setBackgroundImage:[UIImage imageNamed:@"add_button_selected"] forState:UIControlStateSelected];
    }
    return _extendButton;
}

//表情键盘按钮
- (UIButton *)emotionButton{

    if (!_emotionButton) {
        _emotionButton = [[UIButton alloc] init];
        _emotionButton.tag = DavidTextBarEmotionButton;
        _emotionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _emotionButton.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + ButtonMargin, self.height / 2 - ButtonWH / 2, ButtonWH, ButtonWH);
        [_emotionButton setBackgroundColor:[UIColor greenColor]];
        [_emotionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"emotion_button"] forState:UIControlStateNormal];
        //        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
    }
    return _emotionButton;
}

- (void)addObserver{
    //表情页面点击表情的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionPageDidSelect:) name:@"DavidEmotionPageViewDidSelectNotification" object:nil];
    //表情页面的删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDelete:) name:@"DavidEmotionPageViewDeleteNotification" object:nil];
}

- (void)resetButtonStatus{
    self.isEmotionKeyboard = NO;
    self.isExtendKeyboard = NO;
}

-(void)setButtonsSelected:(BOOL)selected
{
    self.extendButton.selected = selected;
    self.emotionButton.selected = selected; 
}

#pragma mark - 发送消息
- (void)doSendMessage{

    if (self.doSendMessageAction) {
        self.doSendMessageAction(self.textView.text);
    }

    //清空输入框
    [self.textView setText:@""];

    //TODO: update frame
}

#pragma mark -- UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES){//点击了发送按钮
        [self doSendMessage];
        return NO;
    }

    if([text length] == 0){
        if(range.length < 1){
            return YES;
        }else{
             //TODO: update frame
            //[self textChanged:_zc_chatTextView];
        }
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self resetButtonStatus];

    if ([self.delegate respondsToSelector:@selector(textbarTextViewDidBeginEnditing:)]) {
        [self.delegate textbarTextViewDidBeginEnditing:self];
    }
}

#pragma mark - 点击表情/扩展键盘按钮
-(void)buttonAction:(UIButton*)button
{
    switch (button.tag) {
        case DavidTextBarExtendButton://点击扩展按钮
        {
            self.isEmotionKeyboard = NO;
            self.isExtendKeyboard = !self.isExtendKeyboard;

            if ([self.delegate respondsToSelector:@selector(textBar:andButtonType:andSelected:)]) {
                [self.delegate textBar:self andButtonType:DavidTextBarExtendButton andSelected:self.isExtendKeyboard];
            }

            if (!self.isExtendKeyboard) {
                [self.textView becomeFirstResponder];
            }else{
                [self.textView resignFirstResponder];
            }
        }
            
            break;
            
        case DavidTextBarEmotionButton://点击表情按钮
        {
            self.isExtendKeyboard = NO;
            self.isEmotionKeyboard = !self.isEmotionKeyboard;

            if ([self.delegate respondsToSelector:@selector(textBar:andButtonType:andSelected:)]) {
                [self.delegate textBar:self andButtonType:DavidTextBarEmotionButton andSelected:self.isEmotionKeyboard];
            }

            if (!self.isEmotionKeyboard) {
                [self.textView becomeFirstResponder];
            }else{
                [self.textView resignFirstResponder];
            }
        }

            break;
            
        case DavidTextBarArtificialButton://点击转人工按钮
            //TODO 点击转人工按钮
            [self upateSubViews];
            break;
    }
}

- (void)upateSubViews{

    self.artificialButton.hidden = YES;

    CGRect frame = self.textView.frame;
    frame.origin.x = ButtonMargin;
    frame.size.width = self.width - 4 * ButtonMargin - 2 * ButtonWH;
    self.textView.frame = frame;

    [self addSubview:self.extendButton];
    [self addSubview:self.emotionButton];
}

#pragma mark - textView NSNotification
-(void)emotionPageDidSelect:(NSNotification*)notification
{
    //插入表情
    NSString *str = notification.userInfo[@"selectedEmotion"];
    [self.textView insertText:str];
}

-(void)emotionDelete:(NSNotification*)notification
{
    //删除文字
    [self.textView deleteBackward];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

@end
