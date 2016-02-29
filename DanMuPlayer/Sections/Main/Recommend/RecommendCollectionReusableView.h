//
//  RecommendCollectionReusableView.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/26.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RecommendCollectionReusableView : UICollectionReusableView

// 赋值
- (void)setValueWithModel:(RecommendModel *)model;

- (void)setValueWithDic:(NSDictionary *)dic;

@end
