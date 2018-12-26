//
//  HFSlipView.m
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import "HFSlipView.h"

#import "UIBezierPath+LxThroughPointsBezier.h"
#import "HFTempView.h"
#import "HFWeatherModel.h"
#import "HFLineModel.h"
//时间的高度
#define timeLayerHeight 25
//风力的高度
#define WindLayerHeight 20
//空气质量高度
#define AirQualityLayerHeight 25

//气温高度
#define AirTemperatureLayerHeight 80

#define tempViewHeight 40

#define RADIUS 1

@interface HFSlipView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) NSMutableArray<HFLineModel*> *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) CAShapeLayer *timerLayer;
@property (nonatomic,strong) HFTempView *tempView;
/**当前模型下标**/
@property (nonatomic,assign) NSInteger currentIndex;
/**当前显示的image下标**/
@property (nonatomic,assign) NSInteger imageIndex;
/**记录所需绘制图片的下标**/
@property (nonatomic,strong) NSMutableArray *indexArray;
/**坐标高度与空气质量的比率**/
@property (nonatomic,assign) CGFloat airQualityScaleY;
/**坐标高度与温度的比率**/
@property (nonatomic,assign) CGFloat airTemperaturecaleY;

@property (strong, nonatomic) NSMutableArray *pointsArray;

@end

@implementation HFSlipView

#pragma mark setter

- (NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

- (NSMutableArray*)indexArray
{
    if (!_indexArray)
    {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

#pragma mark draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.modelPostionArray.count)
    {
        [self drawCircleLayer];
        
        
        [self drawTimerLayer];
        
        [self drawAirTemperatureFillLayer];
        [self drawAirTemperatureLineLayer];
        
        
    }
    UIColor *color = [UIColor redColor];
    [color set];
    
}


/**
 绘制温度填充
 */
- (void)drawAirTemperatureFillLayer {
    HFLineModel *lineModel = self.modelPostionArray.firstObject;
    _tempView.x = lineModel.xPosition + RADIUS - 49.5;
    _tempView.y = lineModel.yPosition - _tempView.height - 5 ;
    
    _tempView.date = _dataArray[0].temper;
    
    
    
    _pointsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _dataArray.count; i ++) {
        HFLineModel *postionModel = _modelPostionArray[i];
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(postionModel.xPosition + 0.5, postionModel.yPosition)];
        [_pointsArray addObject:value];
    }
    [_dataArray enumerateObjectsUsingBlock:^(HFWeatherModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        
        
        if (idx != 24) {
            UIBezierPath *fillPath = [UIBezierPath bezierPath];
            [fillPath moveToPoint:CGPointMake([_pointsArray[idx] CGPointValue].x + 0.5, [_pointsArray[idx] CGPointValue].y)];
            
            [fillPath addBezierThroughPoints:@[_pointsArray[idx], _pointsArray[idx + 1]]];
            
            [fillPath addLineToPoint:CGPointMake([_pointsArray[idx + 1] CGPointValue].x - 0.5, 100)];
            [fillPath addLineToPoint:CGPointMake([_pointsArray[idx + 1] CGPointValue].x - 0.5, 100)];
            [fillPath addLineToPoint:CGPointMake([_pointsArray[idx] CGPointValue].x + 0.5, 100)];
            [fillPath addLineToPoint:CGPointMake([_pointsArray[idx] CGPointValue].x + 0.5, [_pointsArray[idx] CGPointValue].y)];
            layer.path = fillPath.CGPath;
            
            [self.timerLayer addSublayer:layer];
            
        }
        if (idx % 2 == 0) {
            layer.fillColor = [[UIColor colorFromHexString:@"#66C5D6"] CGColor];
        } else {
            layer.fillColor = [[UIColor colorFromHexString:@"#B2E2E9"] CGColor];
        }
        
    }];
    
}

/**
 绘制温度线
 */
- (void)drawAirTemperatureLineLayer {
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[_pointsArray.firstObject CGPointValue]];
    
    [path addBezierThroughPoints:_pointsArray];
    path.lineWidth = 3.0;
    [path addLineToPoint:CGPointMake([_pointsArray.lastObject CGPointValue].x, 100)];
    [path addLineToPoint:CGPointMake([_pointsArray.lastObject CGPointValue].x, 100)];
    [path addLineToPoint:CGPointMake([_pointsArray.firstObject CGPointValue].x, 100)];
    [path addLineToPoint:[_pointsArray.firstObject CGPointValue]];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.lineWidth = 4.0;
    self.lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineLayer];
}

/**
 绘制空气质量
 */
- (void)drawAirQualityLayer {
    [_dataArray enumerateObjectsUsingBlock:^(HFWeatherModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        HFLineModel *postionModel = _modelPostionArray[idx];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        
        
        layer.frame = CGRectMake(postionModel.xPosition + 0.5, self.height - timeLayerHeight - WindLayerHeight - model.airQuality * self.airQualityScaleY - 8 , 24.5, model.airQuality * self.airQualityScaleY);
        
        if (idx != 24) {
            [self.timerLayer addSublayer:layer];
            
        }
        if (idx == 0) {
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.fontSize = 12.f;
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.foregroundColor = [UIColor colorFromHexString:@"#222222"].CGColor;
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            
            textLayer.string = [NSString stringWithFormat:@"%ld", (long)model.airQuality];
            
            textLayer.frame = CGRectMake(50, layer.frame.origin.y - 18, 20, 18);
            [self.timerLayer addSublayer:textLayer];
            
        }
        
        UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(5,5)];
        //创建CALayer图层
        layer.path = maskPath.CGPath;
        layer.fillColor = [[UIColor colorFromHexString:@"#3bb8cc"] CGColor];
        
    }];
}

/**
 绘制风力
 */
- (void)drawWindLayer {
    __block  NSInteger lastBreakIndex = 0;
    __block CGFloat width = 0;
    
    for (NSInteger idx = 0; idx < _dataArray.count; idx ++) {
        HFWeatherModel * _Nonnull model = _dataArray[idx];
        HFLineModel *postionModel = _modelPostionArray[lastBreakIndex];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        
        if (!model.isDrawLine) {
            width = (idx + 1 - lastBreakIndex) * 24.5 + (idx - lastBreakIndex) * 0.5;
            continue;
        } else {
            layer.frame = CGRectMake(postionModel.xPosition + 0.5, self.height - timeLayerHeight - WindLayerHeight, width, WindLayerHeight);
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.fontSize = 12.f;
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            
            textLayer.string = [NSString stringWithFormat:@"%ld级", (long)model.windScale];
            
            textLayer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + 3, layer.frame.size.width, layer.frame.size.height);
            
            [self.timerLayer addSublayer:layer];
            [self.timerLayer addSublayer:textLayer];
            lastBreakIndex = idx;
        }
        
        width = 0;
        UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(5,5)];
        //创建CALayer图层
        layer.path = maskPath.CGPath;
        layer.fillColor = [[UIColor colorFromHexString:@"#156A86"] CGColor];
        
    }
    
}

/**
 绘制圆点
 */
- (void)drawCircleLayer
{
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.fillColor = [[UIColor clearColor] CGColor];
    self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.circleLayer];
    for (HFLineModel *model in _modelPostionArray)
    {
        CAShapeLayer *subLayer = [[CAShapeLayer alloc] init];
        subLayer.fillColor = [UIColor whiteColor].CGColor;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [circle addArcWithCenter:CGPointMake(model.xPosition, model.yPosition) radius:RADIUS
                      startAngle:0
                        endAngle:2*M_PI
                       clockwise:YES];
        subLayer.path = circle.CGPath;
        [self.circleLayer addSublayer:subLayer];
    }
}

/**
 时间
 */
- (void)drawTimerLayer {
    self.timerLayer = [CAShapeLayer layer];
    self.timerLayer.fillColor = [[UIColor greenColor] CGColor];
    self.timerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.timerLayer];
    
    [_dataArray enumerateObjectsUsingBlock:^(HFWeatherModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        HFLineModel *postionModel = _modelPostionArray[idx];
        
        CATextLayer *layer = [CATextLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.fontSize = 12.f;
        
        layer.alignmentMode = kCAAlignmentCenter;
        layer.foregroundColor = [UIColor colorFromHexString:@"#222222"].CGColor;
        //        layer.backgroundColor = [UIColor blueColor].CGColor;
        if (idx != 0) {
            layer.string = model.date;
        }
        
        layer.position = CGPointMake(postionModel.xPosition,self.height - timeLayerHeight / 2 );
        
        layer.bounds = CGRectMake(0, - timeLayerHeight / 4, 50, timeLayerHeight);
        if (idx % 2 == 0) {
            [self.timerLayer addSublayer:layer];
        }
    }];
}

- (void)addWetherImages
{
        for (NSInteger i = 0;i < _dataArray.count; i++)
        {
            HFWeatherModel *model = _dataArray[i];
            HFLineModel *postionModel = _modelPostionArray[i];
            if (model.isDrawImage)
            {
                static NSInteger index = 0;
                UIImageView *imageView = [UIImageView new];
                [self addSubview:imageView];
                imageView.center = CGPointMake(postionModel.xPosition, postionModel.yPosition - 15);
                imageView.bounds = CGRectMake(0, 0, 30, 30);
                imageView.tag = i;
                imageView.image = [UIImage imageNamed:model.imageCode];
                ++ index;
            }
        }
}

#pragma mark postion

- (void)calcuteModelPostion {
    __weak typeof(self) this = self;
    [_dataArray enumerateObjectsUsingBlock:^(HFWeatherModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = [obj.temper floatValue];
        CGFloat xPostion = this.lineSpace*idx + this.leftMargin;
        CGFloat yPostion = (this.maxY - value)*this.airTemperaturecaleY + this.topMargin + 50;
        HFLineModel *lineModel = [HFLineModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [this.modelPostionArray addObject:lineModel];
    }];
}

#pragma mark 运动的view

- (void)addTempView {
    _tempView = [[HFTempView alloc] initWithFrame:CGRectMake(0, -49.5, 35, 25)];
    [self.superScrollView addSubview:_tempView];
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGSize size = scrollView.contentSize;
    CGFloat x = (_dataArray.count - 1) * self.lineSpace * scrollView.contentOffset.x / (size.width - scrollView.width) + self.leftMargin;
    
    if (x > (size.width - self.rightMargin)) {
        HFLineModel *model = self.modelPostionArray.lastObject;
        x = model.xPosition;
        _imageIndex = [_indexArray.lastObject integerValue];
        _currentIndex = self.modelPostionArray.count - 1;
    }
    
    if (x <= self.leftMargin) {
        HFLineModel *model = self.modelPostionArray.firstObject;
        x = model.xPosition;
        _imageIndex = [_indexArray.firstObject integerValue];
        _currentIndex = 0;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        if (_currentIndex == 0) {
            UIImageView *prevImage = [self viewWithTag:[_indexArray.firstObject integerValue]];
            prevImage.alpha = 1;
        } else {
            UIImageView *prevImage = [self viewWithTag:_currentIndex-1];
            if (!prevImage)
            {
                prevImage = [self viewWithTag:_currentIndex+1];
            }
            prevImage.alpha = 1;
        }
        
        UIImageView *currentImage = [self viewWithTag:_currentIndex];
        currentImage.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
    self.alpha = 1;
    CGFloat y = [self getLableyAxisWithX:x] - _tempView.height - 5 > 0 ? [self getLableyAxisWithX:x] - _tempView.height - 5 : 0;
    _tempView.x = x + RADIUS - 49.5;
    _tempView.y = y;
    _tempView.date = _dataArray[_currentIndex].temper;
}

#pragma mark publicMethod

- (void)initConfig
{
    self.lineSpace = 25;
    CGFloat  contentWidth = self.lineSpace*(_dataArray.count - 1) + self.leftMargin + self.rightMargin;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentWidth);
    }];
    [self.superScrollView setContentSize:CGSizeMake(contentWidth, 0)];
    
    self.maxY = 20;
    self.minY  = 100;
    
    //    for (ZYWWetherModel *model in _dataArray) {
    //        self.minY = self.minY < [model.temper integerValue] ? self.minY : [model.temper integerValue];
    //        self.maxY = self.maxY > [model.temper integerValue] ? self.maxY : [model.temper integerValue];
    //    }
    
    [self calcuteWetherCode];
    self.airTemperaturecaleY = 80.000 / 100.00;
    self.airQualityScaleY = 25.000 / 100.000;
}


/**
 计算一个区间天气code，相同code的只保留最后一个
 */
- (void)calcuteWetherCode
{
    for (NSInteger i = 0;i < _dataArray.count; i++)
    {
        HFWeatherModel *mode = _dataArray[i];
        if (i == 0)
        {
            continue;
        }
        
        NSInteger code = [mode.imageCode integerValue];
        HFWeatherModel *prevModel = _dataArray[i-1];
        NSInteger prevCode = [prevModel.imageCode integerValue];
        
        if (code != prevCode || _dataArray.count - 1 == i)
        {
            if (i == _dataArray.count - 1)
            {
                HFWeatherModel *lastModel = _dataArray.lastObject;
                lastModel.isDrawImage = YES;
            }
            
            else
            {
                prevModel.isDrawImage = YES;
            }
            [self.indexArray addObject:@(i-1)];
        }
    }
}

/**
 填充方法
 */
- (void)stockFill
{
    [self layoutIfNeeded];
    [self initConfig];
    [self calcuteModelPostion];
    [self addTempView];
    [self addWetherImages];
    [self drawRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.superScrollView = (UIScrollView*)self.superview;
    self.superScrollView.delegate = self;
}

/**
 获取任意一点的y轴坐标
 
 @param xAxis x轴坐标
 @return y轴坐标
 */
- (CGFloat)getLableyAxisWithX:(CGFloat)xAxis;
{
    CGPoint startPoint,endPoint;
    NSInteger index;
    CGFloat sum = self.leftMargin;
    for (index = 0; index < _dataArray.count; index++)
    {
        sum += self.lineSpace;
        if (xAxis < sum)
        {
            startPoint = CGPointMake(_modelPostionArray[index].xPosition, _modelPostionArray[index].yPosition);
            _currentIndex = index;
            break;
        }
    }
    
    for (NSInteger i = 0; i < self.indexArray.count; i++)
    {
        if (index +1 <= [_indexArray[i] integerValue])
        {
            _imageIndex = [_indexArray[i] integerValue];
            break;
        }
    }
    
    if (index + 1 >= _dataArray.count)
    {
        _imageIndex = [_indexArray.lastObject integerValue];
        return _modelPostionArray[_dataArray.count-1].yPosition;
    }
    
    endPoint = CGPointMake(_modelPostionArray[index+1].xPosition, _modelPostionArray[index+1].yPosition);
    CGFloat k = (endPoint.y - startPoint.y) / (endPoint.x -startPoint.x);
    CGFloat y = k *(xAxis - startPoint.x) + startPoint.y;
    return y;
}

@end
