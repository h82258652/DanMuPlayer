//
//  SubModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubModel : NSObject

@property (nonatomic,assign)NSInteger channelId;  // 频道id
@property (nonatomic,assign)NSInteger comments;  // 评论数
@property (nonatomic,copy)NSString *contentId;  // 内容id
@property (nonatomic,copy)NSString *cover;  // 图片
@property (nonatomic,assign)NSInteger *danmakuSize;  // 弹幕尺寸
@property (nonatomic,copy)NSString *intro;  // 描述
@property (nonatomic,assign)BOOL isArticle; // 是否是文章
@property (nonatomic,assign)BOOL isRecommend;  // 是否是推荐
@property (nonatomic,copy)NSString *title;  // 标题
@property (nonatomic,copy)NSString *username;  // 用户名
@property (nonatomic,copy)NSString *userId;  // 用户id
@property (nonatomic,copy)NSString *userImg;  // 用户头像
@property (nonatomic,assign)BOOL viewOnly;  // 只显示视图
@property (nonatomic,assign)NSInteger views;  // 阅读量

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
