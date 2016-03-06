//
//  DetailVideoModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVideoModel : NSObject

@property (nonatomic,assign)NSInteger channelId;  // 频道id
@property (nonatomic,assign)NSInteger contentId;  // 内容id
@property (nonatomic,copy)NSString *cover;  // 图片
@property (nonatomic,copy)NSString *info;  // 简介
@property (nonatomic,assign)BOOL display; // 是否显示
@property (nonatomic,assign)BOOL isArticle;  // 是否是文章
@property (nonatomic,assign)BOOL isRecommend;  // 是否是推荐
@property (nonatomic,assign)NSInteger owner_id;  // up主id
@property (nonatomic,copy)NSString *owner_name;  // up主昵称
@property (nonatomic,copy)NSString *owner_avatar;  // up主头像
@property (nonatomic,copy)NSString *title;  // 标题
@property (nonatomic,assign)NSTimeInterval releaseDate;  // 发布时间
@property (nonatomic,assign)NSInteger videoCount;  // 合集视频的数量
@property (nonatomic,strong)NSMutableArray *videos;  // 合集
@property (nonatomic,strong)NSArray *tags;  // 标签数组
@property (nonatomic,strong)NSDictionary *visit;  // 访问信息

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
