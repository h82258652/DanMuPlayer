//
//  DetailVideoListModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVideoListModel : NSObject

@property (nonatomic,assign)NSInteger commentId;  // 评论id
@property (nonatomic,assign)NSInteger danmakuId;  // 弹幕库id
@property (nonatomic,assign)NSInteger sourceId;  // 来源id
@property (nonatomic,assign)NSInteger time;  // 播放次数
@property (nonatomic,assign)NSInteger videoId;  // 视频id
@property (nonatomic,copy)NSString *sourceType;  // 来源类型
@property (nonatomic,copy)NSString *title;  // 标题

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;


@end
