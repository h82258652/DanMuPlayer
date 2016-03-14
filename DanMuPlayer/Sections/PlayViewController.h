//
//  PlayViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailVideoModel.h"

typedef void(^ModifyFullScreenByBtn)(BOOL);
@interface PlayViewController : UIViewController

@property (nonatomic,strong)AVPlayer *mainPlayer;  // 播放器

/** 赋值 */
- (void)setUpWithModel:(DetailVideoModel *)model;

/** 赋值 */
- (void)setUpWithVideoId:(NSInteger)videoId;

/** 接收到要跳转到相关界面的通知 */
- (void)pushAboutVideos;

/** 切换全屏 */
- (void)modifyFullScreenOrNo:(BOOL)full;

/** 切换到其他播放源，此处停止播放 */
- (void)otherPlayerURLStopCurrentPage;

@property (nonatomic,copy)ModifyFullScreenByBtn modifyFSBB;  // 使用全屏按钮切换全屏

@end
