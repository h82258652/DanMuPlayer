//
//  VideoCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCellModel.h"
#import "SubModel.h"
#import "DetailVideoAboutModel.h"

@interface VideoCollectionViewCell : UICollectionViewCell

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model;

/** submodel 赋值 */
- (void)setValueWithSubModel:(SubModel *)model;

/** 视频相关model赋值 */
- (void)setValueWithAboutModel:(DetailVideoAboutModel *)model;

@end
