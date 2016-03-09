//
//  NewComicModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewComicListModel : NSObject

@property (nonatomic,strong)NSString *cover;  // 图片
@property (nonatomic,assign)NSInteger bangumiId;  // 番剧id
@property (nonatomic,strong)NSString *intro;  // 简介
@property (nonatomic,strong)NSString *lastVideoName;  // 更新至
@property (nonatomic,strong)NSString *title;  // 标题

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
