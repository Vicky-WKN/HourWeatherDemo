//
//  ViewController.m
//  HourWeatherDemo
//
//  Created by Ailsa on 2018/12/26.
//  Copyright © 2018 Ailsa. All rights reserved.
//

#import "ViewController.h"
#import "HFSlipView.h"

@interface ViewController ()
@property (nonatomic,strong) HFSlipView *slipLine;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self draw24HourWeather];
}

- (void)draw24HourWeather {
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(100));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(@(200));
    }];
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor grayColor];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _slipLine = [[HFSlipView alloc] init];
    _slipLine.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_slipLine];
    [_slipLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NSMutableArray *wetherArray = [NSMutableArray array];
    NSArray *wetherCode = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    //产生时间和温度
    for (NSInteger i = 0;i<25;i++)
    {
        NSInteger code = arc4random() % (wetherCode.count-1) +1;
        NSInteger temper = arc4random() % 25 + 15;
        NSString *time = [NSString stringWithFormat:@"%ld:00",i];
        if ([time isEqualToString:@"24:00"]) {
            time = @"0:00";
        }
       
        HFWeatherModel *model = [HFWeatherModel new];
        [wetherArray addObject:model];
        model.date = time;
        model.isDrawImage = YES;
        model.temper = [NSString stringWithFormat:@"%ld°",temper];
        if ((i+1) % 3 == 0)
        {
            model.imageCode = [NSString stringWithFormat:@"%ld",code];
        }
    }
    
    static NSInteger lastWetherIndex = 0;
    for (NSInteger i = 0;i<wetherArray.count;i++) {
        if ((i+1) % 3 == 0) {
            for (NSInteger index = lastWetherIndex; index<i; index++) {
                HFWeatherModel *localModel = wetherArray[i];
                HFWeatherModel *model = wetherArray[index];
                model.imageCode = [NSString stringWithFormat:@"%@",localModel.imageCode];
            }
            lastWetherIndex = i;
        }
    }
    
    _slipLine.dataArray = wetherArray;
    _slipLine.leftMargin = 50;
    _slipLine.rightMargin = 0;
    _slipLine.topMargin = 0;
    _slipLine.bottomMargin = 0;
    
    [_slipLine stockFill];
}


@end
