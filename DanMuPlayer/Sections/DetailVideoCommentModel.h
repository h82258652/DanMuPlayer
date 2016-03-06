//
//  DetailVideoCommentModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVideoCommentModel : NSObject

@property (nonatomic,assign)NSInteger comment_Id;  // 评论id
@property (nonatomic,assign)NSInteger quoteId;  // 引用的评论的id
@property (nonatomic,assign)NSInteger refCount;  // 回复此评论的数量
@property (nonatomic,copy)NSString *content;  // 评论内容
@property (nonatomic,assign)NSInteger userId;  // 用户id
@property (nonatomic,copy)NSString *username;  // 用户名
@property (nonatomic,assign)NSInteger floor;  // 楼层数
@property (nonatomic,assign)NSInteger contentId;  // 所评论的内容的id
@property (nonatomic,assign)BOOL nameRed;  // 是否红名
@property (nonatomic,assign)BOOL avatarFrame;  // 是否有头像
@property (nonatomic,copy)NSString *avatar;  // 头像
@property (nonatomic,assign)NSTimeInterval time;  // 发布时间

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
