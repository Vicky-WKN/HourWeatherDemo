//
//  HFLineModel.m
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import "HFLineModel.h"

@implementation HFLineModel

+ (instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color
{
    HFLineModel *model = [[self alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    model.lineColor = color;
    return model;
}

@end
