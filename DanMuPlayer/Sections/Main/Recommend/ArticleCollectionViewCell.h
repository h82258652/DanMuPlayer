//
//  ArticleCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCellModel.h"
#import "SubModel.h"

@interface ArticleCollectionViewCell : UICollectionViewCell

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model;


@end
