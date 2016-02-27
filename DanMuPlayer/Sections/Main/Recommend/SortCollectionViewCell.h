//
//  SortCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCellModel.h"

@interface SortCollectionViewCell : UICollectionViewCell

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model;

@end
