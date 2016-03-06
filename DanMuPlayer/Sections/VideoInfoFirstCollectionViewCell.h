//
//  VideoInfoFirstCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

typedef void(^MotifyCellNumBlock)(NSDictionary *);\

@interface VideoInfoFirstCollectionViewCell : UICollectionViewCell

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model withBlock:(MotifyCellNumBlock)block;

/** 动态高度 */
+ (CGFloat)heightOfCellWithModel:(DetailVideoModel *)model;


@end
