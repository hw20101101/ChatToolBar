//
//  DavidEmotionPageView.m
//  ChatKeyboardDemo
//
//  Created by DavidLee on 15/12/31.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidEmotionPageView.h"
#import "UIView+Extension.h"
#import "NSString+Emoji.h"

@interface DavidEmotionPageView ()

/**
 删除按钮
 */
@property(nonatomic,strong) UIButton *deleteButton;

@end

@implementation DavidEmotionPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //删除按钮
        self.deleteButton = [[UIButton alloc] init];
        [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.deleteButton setTitle:@"DEL" forState:UIControlStateNormal];
        [self.deleteButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.deleteButton  addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setEmotionArray:(NSArray *)emotionArray
{
    _emotionArray = emotionArray;
    NSUInteger count = emotionArray.count;
    for (int i = 0 ; i < count; i++){
        UIButton *button = [[UIButton alloc] init];         
        NSDictionary *emotionDic = emotionArray[i];
        NSString *emotionCode = emotionDic[@"code"];
        
        //emotion.code : 十六进制->表情
        [button setTitle:[NSString emojiWithStringCode:emotionCode] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [button addTarget:self action:@selector(emotionButtonAction:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.emotionArray.count;
    CGFloat inset = 10;//内边距
    CGFloat btnWidth = (self.width - 2 * inset) / 7;
    CGFloat btnHeight = (self.height - 2 * inset) / 3;
    
    for (int i = 0 ; i < count; i++){
        UIButton *button = (UIButton*)self.subviews[i];
        button.width = btnWidth;
        button.height = btnHeight;
        button.x = inset + (i%7) * btnWidth;
        button.y = inset + (i/7) * btnHeight;
    }
    
    self.deleteButton.width  = btnWidth;
    self.deleteButton.height = btnHeight;
    self.deleteButton.y = self.height - btnHeight - inset;
    self.deleteButton.x = self.width - inset - btnWidth;
    [self addSubview:self.deleteButton];
}

#pragma mark - 点击 emoji 按钮
-(void)emotionButtonAction:(UIButton*)button
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"selectedEmotion"] = button.titleLabel.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DavidEmotionPageViewDidSelectNotification" object:nil userInfo:userInfo];
}

#pragma mark - 点击删除按钮
-(void)deleteButtonAction:(UIButton*)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DavidEmotionPageViewDeleteNotification" object:nil];
}

@end
