//
//  UIBezierPath+Draw.h
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Draw)

/**
 绘制单个折线

 @param linesArray 单个折线数组
 @return 绘制的path
 */
+ (UIBezierPath*)drawLine:(NSMutableArray*)linesArray;

/**
 绘制多个折线
 
 @param linesArray 多个折线数组
 @return 绘制的path数组
 */
+ (NSMutableArray<__kindof UIBezierPath*>*)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray;


@end
