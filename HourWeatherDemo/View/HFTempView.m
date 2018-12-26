//
//  HFTempView.m
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import "HFTempView.h"


#define RADIUS 5
#define AllowSize  CGSizeMake(6, 6)

@interface HFTempView ()
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) UILabel *tempLabel;

@end

@implementation HFTempView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addCirLayer];
        [self addSubview];
    }
    return self;
}

//移动方块
- (void)addCirLayer
{
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.strokeColor = [[UIColor colorFromHexString:@"#156A86"] CGColor];
    self.lineLayer.fillColor = [[UIColor colorFromHexString:@"#156A86"] CGColor];
    self.lineLayer.lineWidth = 1;
    self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineLayer];
    
    
    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                  byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight | UIRectCornerBottomRight
                                                        cornerRadii:CGSizeMake(10,10)];
    self.lineLayer.path = maskPath.CGPath;
}

- (void)addSubview
{
    _tempLabel = [UILabel new];
    [self addSubview:_tempLabel];
    _tempLabel.textColor = [UIColor whiteColor];
    _tempLabel.font = [UIFont systemFontOfSize:14];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
}

- (void)setDate:(NSString *)date
{
    if (_date != date)
    {
        _date = date;
        _tempLabel.text = _date;
    }
}


@end
