//
//  RollPlayCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RollPlayCollectionViewCell : UICollectionViewCell

// 使用model赋值
- (void)setValueWithModel:(RecommendModel *)model;

@end
