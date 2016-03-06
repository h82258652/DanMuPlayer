//
//  DetailVideoAboutModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVideoAboutModel : NSObject

@property (nonatomic,copy)NSString *contentId;  // 内容id
@property (nonatomic,copy)NSString *title;  // 标题
@property (nonatomic,copy)NSString *info;  // 描述
@property (nonatomic,assign)NSInteger channelId;  // 频道id
@property (nonatomic,assign)NSInteger parentChannelId;  // 父频道id
@property (nonatomic,assign)NSInteger views;  // 观看数
@property (nonatomic,assign)NSInteger stows;  // 装载数
@property (nonatomic,assign)NSInteger comments;  // 评论数
@property (nonatomic,assign)NSInteger userId;  // 用户id
@property (nonatomic,copy)NSString *avatar;  // 用户头像
@property (nonatomic,copy)NSString *titleImg;  // 标题图片
@property (nonatomic,copy)NSString *username;  // 用户名
@property (nonatomic,assign)NSTimeInterval releaseDate;  // 发布时间
@property (nonatomic,copy)NSString *sourceType;  // 类型
@property (nonatomic,assign)NSInteger time;  // 播放次数

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
