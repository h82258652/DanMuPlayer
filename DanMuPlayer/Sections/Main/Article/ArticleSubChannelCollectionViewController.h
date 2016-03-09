//
//  ArticleSubChannelCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface ArticleSubChannelCollectionViewController : UICollectionViewController

/** 加载数据 */
- (void)loadDateWithSubChannelId:(NSInteger)subChannelId;

- (void)loadDateWithModel:(RecommendModel *)model withIndex:(NSInteger)index;

@end
