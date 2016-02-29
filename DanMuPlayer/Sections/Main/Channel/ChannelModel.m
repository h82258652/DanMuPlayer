//
//  ChannelModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelModel.h"
#import "ChannelSubModel.h"

@implementation ChannelModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        // 将子频道封装成子model
        [self changeChildChannels];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.channel_Id = [value integerValue];
    }
}

// 将子频道封装成子model
- (void)changeChildChannels {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.childChannels) {
        ChannelSubModel *model = [[ChannelSubModel alloc]initWithDic:dic];
        [array addObject:model];
    }
    self.childChannels = [NSMutableArray arrayWithArray:array];
    
}

@end
