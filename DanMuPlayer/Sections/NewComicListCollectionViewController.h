//
//  NewComicListCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewComicListCollectionViewController : UICollectionViewController

@property (nonatomic,copy)NSString *name;

/** 请求数据 */
- (void)loadDataWithChannelId:(NSInteger)channelId;

@end
