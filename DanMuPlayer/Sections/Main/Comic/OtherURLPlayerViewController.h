//
//  OtherURLPlayerViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/12.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherURLPlayerViewController : UIViewController

@property (nonatomic,strong)NSString *mainURLStr;  // 主网址

/** 加载网页 */
- (void)addWebViewWithURLStr:(NSString *)str;

@end
