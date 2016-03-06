//
//  DetailVideoModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoModel.h"
#import "DetailVideoListModel.h"

@implementation DetailVideoModel

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        // 封装视频model
        [self dicToModel];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.info = value;
    } else if ([key isEqualToString:@"owner"]) {
        NSDictionary *dic = value;
        self.owner_id = [dic[@"id"] integerValue];
        self.owner_name = dic[@"name"];
        self.owner_avatar = dic[@"avatar"];
    }
    
}
/** 封装视频model */
- (void)dicToModel {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.videos) {
        DetailVideoListModel *model = [[DetailVideoListModel alloc]initWithDic:dic];
        [array addObject:model];
    }
    self.videos = array;
}

@end
