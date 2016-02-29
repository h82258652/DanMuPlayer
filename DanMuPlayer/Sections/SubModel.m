//
//  SubModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SubModel.h"

@implementation SubModel

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.intro = value;
    } else if ([key isEqualToString:@"user"]) {
        NSDictionary *dic = value;
        [self setValuesForKeysWithDictionary:dic];
    }
}

@end
