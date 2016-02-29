//
//  ChannelModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject

@property (nonatomic,strong)NSMutableArray *childChannels;  // 子频道数组
@property (nonatomic,assign)NSInteger channel_Id; // 频道id
@property (nonatomic,copy)NSString *img;  // 频道图标
@property (nonatomic,copy)NSString *name;  // 频道名
@property (nonatomic,assign)NSInteger priority;  // 优先级
@property (nonatomic,assign)NSInteger type;  // 类型

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
