//
//  Header.h
//  ChatToolBar
//
//  Created by 快摇002 on 2018/9/26.
//  Copyright © 2018年 aiitec. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

#define IPHONE_X (HEIGHT == 812.f || HEIGHT == 896.f)
#define STATUSBAR_HEIGHT (IPHONE_X ? 44.f : 20.f)
#define TOPBAR_HEIGHT (STATUSBAR_HEIGHT + 44)

#define DavidTextBarHeight 49
#define ExtendViewHeight 220

#endif /* Header_h */
