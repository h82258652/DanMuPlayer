//
//  PlayViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

@interface PlayViewController : UIViewController

/** 赋值 */
- (void)setUpWithModel:(DetailVideoModel *)model;

/** 赋值 */
- (void)setUpWithVideoId:(NSInteger)videoId;

/** 接收到要跳转到相关界面的通知 */
- (void)pushAboutVideos;

@end
