//
//  RecommendModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/25.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RecommendModel.h"
#import "RecommendCellModel.h"
#import "DataHelper.h"

@implementation RecommendModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        // 赋值
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.recommend_id = [value integerValue];
    } else if ([key isEqualToString:@"type"]) {
        self.type_id = [value[@"id"] integerValue];
    }
}

- (void)setNameOfMessage:(NSString *)nameOfMessage {
    if (_nameOfMessage != nameOfMessage) {
        _nameOfMessage = [nameOfMessage copy];
    }
    
    // 如果未请求到item的数据，则立即请求
    if (self.contents.count != self.contentCount) {
        // 异步请求数据
        [self loadOtherData];
    } else {
        // 封装子model
        [self changeContents];
    }
    
}

// 封装子model
- (void)changeContents {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.contents) {
        RecommendCellModel *model = [[RecommendCellModel alloc]initWithDic:dic];
        [array addObject:model];
    }
    self.contents = [NSMutableArray arrayWithArray:array];
    
}

// 请求其他数据
- (void)loadOtherData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/%ld",kRegionsURLStr,self.recommend_id];
//    NSLog(@"%@",urlStr);
    
//    NSLog(@"%@",self.nameOfMessage);
    
    [DataHelper getDataSourceForCommendWithURLStr:urlStr withName:self.nameOfMessage withBlock:^(NSDictionary *dic) {
        self.contents = [NSMutableArray  arrayWithArray:dic[@"dataArray"]];
        // 给self.dataSource发送通知消息，让其改变数据并刷新页面
    }];
}

@end
