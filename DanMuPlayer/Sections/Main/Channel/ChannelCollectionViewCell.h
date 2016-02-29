//
//  ChannelCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"
#import "RecommendModel.h"

@interface ChannelCollectionViewCell : UICollectionViewCell

// 赋值
- (void)setValueWithModel:(ChannelModel *)model;

/** 另一种赋值 */
- (void)setValueWithMainModel:(RecommendModel *)model;

@end
