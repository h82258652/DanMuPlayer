//
//  SubCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCollectionViewController : UICollectionViewController

@property (nonatomic,copy)NSString *name;

/** 请求数据 */
- (void)loadDataWithChannelId:(NSInteger)channelId;

@end
