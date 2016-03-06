//
//  DetailVideoViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVideoViewController : UIViewController

/** 请求数据 */
- (void)loadDataWithVideoId:(NSInteger)videoId;

@end
