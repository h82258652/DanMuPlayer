//
//  DetailVideoAboutCollectionViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeVideoIdBlock)(NSInteger);
@interface DetailVideoAboutCollectionViewController : UICollectionViewController

/** 请求数据 */
- (void)loadDataWithVideoId:(NSInteger)videoId;

/** 切换到相关视频 */
@property (nonatomic,copy)ChangeVideoIdBlock changeVideoIdBlock;

@end
