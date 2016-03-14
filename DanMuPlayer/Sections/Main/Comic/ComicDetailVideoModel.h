//
//  ComicDetailVideoModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicDetailVideoModel : NSObject


@property (nonatomic,assign)NSInteger bangumiId;  // 所属集合的id
@property (nonatomic,assign)NSInteger danmakuId;  // 弹幕id
@property (nonatomic,strong)NSString *sourceId;  // 数据id
@property (nonatomic,strong)NSString *sourceType;  // 数据类型
@property (nonatomic,strong)NSString *title;  // 名称
@property (nonatomic,assign)NSInteger videoId;  // 视频id
@property (nonatomic,strong)NSString *urlMobile;  // 视频网址

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
