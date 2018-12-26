//
//  HFLineModel.h
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFLineModel : NSObject
// x 位置
@property (nonatomic,assign) CGFloat xPosition;
// y 位置
@property (nonatomic,assign) CGFloat yPosition;
// 线的颜色
@property (nonatomic,strong) UIColor *lineColor;

+ (instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color;


@end
