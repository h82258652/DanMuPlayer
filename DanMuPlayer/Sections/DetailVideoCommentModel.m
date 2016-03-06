//
//  DetailVideoCommentModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoCommentModel.h"

@implementation DetailVideoCommentModel

/** 初始化方法 */
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        
        self.comment_Id = [value integerValue];
    }
}


@end
