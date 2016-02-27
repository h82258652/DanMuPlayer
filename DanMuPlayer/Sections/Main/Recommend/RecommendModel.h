//
//  RecommendModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/25.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic,assign)NSInteger channelId;  // 频道id
@property (nonatomic,assign)NSInteger contentCount; // 内容数量
@property (nonatomic,strong)NSMutableArray *contents;  // 内容信息
@property (nonatomic,assign)NSInteger recommend_id;  // id
@property (nonatomic,copy)NSString *image;  // 分区图片网址
@property (nonatomic,copy)NSString *name;  // 分区名
@property (nonatomic,assign)NSInteger sort;  // 排序
@property (nonatomic,assign)NSInteger type_id; // 类型id

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
