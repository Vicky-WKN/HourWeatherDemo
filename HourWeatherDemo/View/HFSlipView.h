//
//  HFSlipView.h
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFWeatherModel.h"

@interface HFSlipView : UIView
//格间距
@property (nonatomic,assign) CGFloat lineSpace;
//y  值最大
@property (nonatomic,assign) CGFloat maxY;
//y  值最小
@property (nonatomic,assign) CGFloat minY;

//上下左右
@property (nonatomic,assign) CGFloat leftMargin;
@property (nonatomic,assign) CGFloat rightMargin;
@property (nonatomic,assign) CGFloat topMargin;
@property (nonatomic,assign) CGFloat bottomMargin;

@property (nonatomic,strong) NSMutableArray<HFWeatherModel*>*dataArray;

- (void)stockFill;

@end
