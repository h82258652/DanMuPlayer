//
//  ComicDetailModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComicDetailVideoModel.h"

@interface ComicDetailModel : NSObject

@property (nonatomic,assign)NSInteger bangumiId;  // 数据id
@property (nonatomic,strong)NSString *cover;  // 图片
@property (nonatomic,strong)NSString *intro;  // 简介
@property (nonatomic,strong)ComicDetailVideoModel *latestVideoComic;  // 最近的番剧
@property (nonatomic,strong)NSString *title;  // 标题
@property (nonatomic,assign)NSInteger videoCount;  // 番剧总数
@property (nonatomic,strong)NSMutableArray *videosArr;  // 视频信息数组
@property (nonatomic,strong)NSDictionary *visit;  // 访问信息






/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
