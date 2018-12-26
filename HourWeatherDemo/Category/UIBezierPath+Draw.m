//
//  UIBezierPath+Draw.m
//

#import "UIBezierPath+Draw.h"
#import "HFLineModel.h"
@implementation UIBezierPath (Draw)

+ (UIBezierPath*)drawLine:(NSMutableArray*)linesArray
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [linesArray enumerateObjectsUsingBlock:^(HFLineModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [path moveToPoint:CGPointMake(obj.xPosition,obj.yPosition)];
        }
        
        else
        {
            [path addLineToPoint:CGPointMake(obj.xPosition,obj.yPosition)];
        }
    }];
    return path;
}

+ (NSMutableArray<__kindof UIBezierPath*>*)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray
{
     NSAssert(0 != linesArray.count && NULL != linesArray, @"传入的数组为nil ,打印结果---->>%@",linesArray);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSMutableArray *lineArray in linesArray)
    {
        UIBezierPath *path = [UIBezierPath drawLine:lineArray];
        [resultArray addObject:path];
    }
    return resultArray;
}

-(void)drawCurveLine:(NSMutableArray*)valueArray
{
    
}

@end
