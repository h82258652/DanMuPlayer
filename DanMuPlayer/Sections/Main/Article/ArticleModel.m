//
//  ArticleModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"article"])
    {
        self.article_content = value[@"content"];
    } else if ([key isEqualToString:@"description"])
    {
        self.info = value;
    } else if ([key isEqualToString:@"owner"])
    {
        self.owner_id = [value[@"id"] integerValue];
        self.owner_name = value[@"name"];
        self.owner_avatar = value[@"avatar"];
    } 
}

@end
