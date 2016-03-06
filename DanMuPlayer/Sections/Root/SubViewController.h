//
//  SubViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"
#import "RecommendModel.h"

@interface SubViewController : UIViewController

/** 使用主model创建 */
- (void)setUpWithRecommendModel:(RecommendModel *)model withCustomIndex:(NSInteger)index;

/** 使用频道model创建 */
- (void)setUpWithChannelModel:(ChannelModel *)model WithCustomIndex:(NSInteger)index;

@end
