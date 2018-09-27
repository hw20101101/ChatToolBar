//
//  DavidTextBar.h
//  KeyboradDemn 客服聊天界面的键盘工具条
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DavidTextBarExtendButton,//扩展按钮
    DavidTextBarEmotionButton,//表情按钮
    DavidTextBarArtificialButton,//转人工按钮
} DavidTextBarButtonType;//按钮类型

@class DavidTextBar;
@protocol DavidTextBarDelegate <NSObject>

-(void)textBar:(DavidTextBar*)textBar andButtonType:(DavidTextBarButtonType)buttonType andSelected:(BOOL)selected;
-(void)textbarTextViewDidBeginEnditing:(DavidTextBar*)texBar;

@end

@interface DavidTextBar : UIView

@property(nonatomic,assign) id<DavidTextBarDelegate> delegate;

/**
 消息发送事件
 */
@property (copy, nonatomic) void (^doSendMessageAction)(NSString *model);

/**
 重置表情按钮和扩展按钮的图片
 */
- (void)resetButtonStatus;

@end
