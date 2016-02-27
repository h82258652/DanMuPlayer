//
//  BannerCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/26.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCellModel.h"

@interface BannerCollectionViewCell : UICollectionViewCell

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model;

@end
