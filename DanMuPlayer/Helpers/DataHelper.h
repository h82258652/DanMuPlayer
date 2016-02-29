//
//  DataHelper.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InputBlock)(NSDictionary *);

@interface DataHelper : NSObject

/** 初始化方法 */
+ (void)sharedHelper;

/** 传入网址和block，请求推荐界面数据 */
+ (void)getDataSourceForCommendWithURLStr:(NSString *)urlStr withName:(NSString *)name withBlock:(InputBlock)block;

/** 传入网址，请求频道界面数据 */
+ (void)getDataSourceForChannelsWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block;

/** 传入网址，请求子界面数据 */
+ (void)getDataSourceForSubWithURLStr:(NSString *)urlStr andParameters:(NSDictionary *)parameters withBlock:(InputBlock)block;

@end
