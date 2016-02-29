//
//  FooterModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "FooterModel.h"

@implementation FooterModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        // 赋值
        [self setValuesForKeysWithDictionary:dic];
//        NSLog(@"dic");
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.footer_id = [value integerValue];
    }
}

@end
