//
//  UIImage+Color.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/11.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

/** 颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [[UIColor colorWithCGColor:color.CGColor]set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end
