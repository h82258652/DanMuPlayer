//
//  ComicInfoCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicDetailModel.h"
#import "ComicDetailVideoModel.h"

typedef void(^changeVideoIdBlock)(ComicDetailVideoModel *);

@interface ComicInfoCollectionViewController : UICollectionViewController

/** 点击更改播放视频地址的block */
@property (nonatomic,copy)changeVideoIdBlock changeVideoIdBlock;

/** 赋值 */
- (void)setValueWithComicDetailModel:(ComicDetailModel *)model;


@end
