//
//  FooterModel.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FooterModel : NSObject

@property (nonatomic,assign)NSInteger actionId;
@property (nonatomic,assign)NSInteger channelId;
@property (nonatomic,assign)NSInteger footer_id;  // id
@property (nonatomic,copy)NSString *image;  // 分区图片网址
@property (nonatomic,copy)NSString *name;  // 分区名
@property (nonatomic,assign)NSInteger regionId;  // 作为页脚model用到的一个属性，所属类型的id

@property (nonatomic,copy)NSString *nameOfMessage; // 通知发送的名字

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
