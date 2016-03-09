//
//  ArticleModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

@property (nonatomic,strong)NSString *article_content;  // 文章内容
@property (nonatomic,assign)NSInteger channelId;  // 所属频道id
@property (nonatomic,assign)NSInteger contentId;  // 内容id
@property (nonatomic,strong)NSString *cover;  // 图片
@property (nonatomic,strong)NSString *info; // 信息
@property (nonatomic,strong)NSString *owner_avatar;  // 头像
@property (nonatomic,strong)NSString *owner_name;  // 姓名
@property (nonatomic,assign)NSInteger owner_id;  // 用户id
@property (nonatomic,assign)NSTimeInterval releaseDate;  // 发布日期
@property (nonatomic,strong)NSString *title;  // 标题
@property (nonatomic,assign)NSTimeInterval updateAt;  // 更新时间
@property (nonatomic,strong)NSDictionary *visit;  // 访问信息

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
