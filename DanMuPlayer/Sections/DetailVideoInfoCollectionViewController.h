//
//  DetailVideoCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

typedef void(^ChangeVideoIdBlock)(NSInteger);
@interface DetailVideoInfoCollectionViewController : UICollectionViewController

/** 请求数据 */
- (void)loadDataWithModel:(DetailVideoModel *)model;

/** 切换选集 */
@property (nonatomic,copy)ChangeVideoIdBlock changeVideoIdBlock;

@end
