//
//  RecommendCellModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/25.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RecommendCellModel.h"

@implementation RecommendCellModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.cellId = [value integerValue];
    } else if ([key isEqualToString:@"owner"]) {
        NSDictionary *dic = value;
        self.owner_Id = [dic[@"id"] integerValue];
        self.owner_name = dic[@"name"];
        self.owner_avatar = dic[@"avatar"];
    }
}

@end
