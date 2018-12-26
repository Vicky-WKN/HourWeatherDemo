//
//  UIColor+HexString.m
//  HoursForecast
//
//  Created by EastElsoft on 2017/8/25.
//  Copyright © 2017年 XiFeng. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+(UIColor *)colorFromHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cString];
//    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
