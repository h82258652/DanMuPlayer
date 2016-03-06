//
//  MoreHotCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/1.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreHotCollectionViewController : UICollectionViewController

@property (nonatomic,copy)NSString *name;  // 分区名

/** 请求数据 */
- (void)loadDataWithChannelId:(NSInteger)channelId;

@end
