//
//  UIImage+Color.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/11.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/** 颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
