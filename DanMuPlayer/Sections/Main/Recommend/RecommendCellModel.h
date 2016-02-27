//
//  RecommendCellModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/25.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendCellModel : NSObject

@property (nonatomic,assign)NSInteger actionId;
@property (nonatomic,assign)NSInteger channelId;
@property (nonatomic,assign)NSInteger cellId;  // 本视频id
@property (nonatomic,copy)NSString *image;  // 图片
@property (nonatomic,copy)NSString *intro;  // 简介
@property (nonatomic,assign)NSInteger regionId;
@property (nonatomic,assign)NSInteger releaseAt; // 发布时间
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString *title;  // 标题
@property (nonatomic,copy)NSString *url;  // 视频编号
@property (nonatomic,strong)NSDictionary *visit;  // 访问信息字典
@property (nonatomic,strong)NSDictionary *latestBangumiVideo;  // 最近更新信息

@property (nonatomic,copy)NSString *owner_name;  // up主
@property (nonatomic,copy)NSString *owner_avatar;  // up主头像
@property (nonatomic,assign)NSInteger owner_Id;  // up主id

// 初始化方法
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
