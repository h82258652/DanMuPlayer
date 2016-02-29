//
//  ChannelSubModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelSubModel : NSObject

@property (nonatomic,assign)NSInteger sub_Id;  // id
@property (nonatomic,copy)NSString *img;  // 照片
@property (nonatomic,copy)NSString *name;  // 子频道名字
@property (nonatomic,assign)NSInteger pid;  // 未知 id
@property (nonatomic,assign)NSInteger priority;  // 优先级
@property (nonatomic,assign)NSInteger type;  // 类型

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
