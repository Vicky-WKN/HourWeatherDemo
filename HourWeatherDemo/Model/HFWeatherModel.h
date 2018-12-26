//
//  HFWeatherModel.h
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFWeatherModel : NSObject
//时间
@property (nonatomic,copy) NSString *date;
//图片
@property (nonatomic,strong) NSString *imageCode;
//温度
@property (nonatomic,copy) NSString *temper;
//是否画图片
@property (nonatomic,assign) BOOL isDrawImage;
//风力
@property (assign, nonatomic) NSInteger windScale;
//风力之间是否加线
@property (assign, nonatomic) BOOL isDrawLine;
//空气质量
@property (assign, nonatomic) NSInteger airQuality;

@end
