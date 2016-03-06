//
//  SortTableViewController.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/6.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortTableViewController : UITableViewController

/** 请求数据 */
- (void)loadDataWithURLStr:(NSString *)urlStr;

@end
