//
//  DavidMediaView.m
//  KeyboradDemn 扩展界面
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidMediaView.h"
#import "UIView+Extension.h"

@interface DavidMediaView()

@end

@implementation DavidMediaView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setButtonWithImage:@"camera_button" andButtonType:DavidMediaViewOrderButton andName:@"订单"];
        [self setButtonWithImage:@"photo_button" andButtonType:DavidMediaViewPhotoButton andName:@"照片"];
    }
    return self;
}

-(void)setButtonWithImage:(NSString*)image andButtonType:(DavidMediaViewButtonType)buttonType andName:(NSString*)name
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = buttonType;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    button.layer.cornerRadius = 5;
    //    button.layer.borderWidth = 0.5;
    //    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:button];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidthHeight = 60;
    CGFloat disWidth = (self.width - 4 * buttonWidthHeight) / 5;
    CGFloat originY = (self.height - 2 * buttonWidthHeight) / 3;
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIButton *button = (UIButton*)self.subviews[i];
        button.x = buttonWidthHeight * i + (i + 1) * disWidth;
        button.y = originY;
        button.width = buttonWidthHeight;
        button.height = buttonWidthHeight;
        button.titleEdgeInsets = UIEdgeInsetsMake(40-15/2 + 8, -button.imageView.frame.size.width, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15/2,15, -button.titleLabel.frame.size.width+15/2);
    }
}

-(void)buttonAction:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(mediaView:didClickAtButton:)]) {
        [self.delegate mediaView:self didClickAtButton:button.tag];
    }
}
 
@end
