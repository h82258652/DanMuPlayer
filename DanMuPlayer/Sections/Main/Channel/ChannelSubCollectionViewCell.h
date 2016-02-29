//
//  ChannelSubCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelSubModel.h"
#import "RecommendCellModel.h"

@interface ChannelSubCollectionViewCell : UICollectionViewCell

/** 赋值 */
- (void)setValueWithModel:(ChannelSubModel *)model;

/** 赋值 */
- (void)setValueWithCellModel:(RecommendCellModel *)model;

@end
