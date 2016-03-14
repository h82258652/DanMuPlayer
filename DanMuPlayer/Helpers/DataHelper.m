//
//  DataHelper.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DataHelper.h"
#import "AFHTTPSessionManager.h"

#import "RecommendModel.h"
#import "RecommendCellModel.h"

#import "ChannelModel.h"
#import "ChannelSubModel.h"

#import "FooterModel.h"

#import "SubModel.h"

#import "DetailVideoModel.h"

#import "DetailVideoCommentModel.h"
#import "DetailVideoAboutModel.h"

#import "ComicDetailModel.h"

DataHelper *helper = nil;
@implementation DataHelper

+ (void)sharedHelper {
    static dispatch_once_t ontToken;
    dispatch_once(&ontToken, ^{
        helper = [[DataHelper alloc]init];
    });
}

#pragma mark --传入网址，请求推荐界面数据
+ (void)getDataSourceForCommendWithURLStr:(NSString *)urlStr withName:(NSString *)name withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"data"];
            
            for (NSDictionary *dic in array) {
                RecommendModel *model = [[RecommendModel alloc]initWithDic:dic];
                model.nameOfMessage = name;
                [dataSource addObject:model];
                
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            block(dataDic);
        } else if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]] && [responseObject[@"data"][@"contents"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            
            for (NSDictionary *dic in responseObject[@"data"][@"contents"]) {
                RecommendCellModel *model = [[RecommendCellModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            dataSource = [NSMutableArray arrayWithArray:array];
            
            NSString *model_id = [responseObject[@"data"][@"id"] stringValue];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            [dataDic setValue:model_id forKey:@"model_id"];
            
            if ([responseObject[@"data"][@"menus"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *menusArray = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in responseObject[@"data"][@"menus"]) {
                    FooterModel *model = [[FooterModel alloc]initWithDic:dic];
                    [menusArray addObject:model];
                }
                [dataDic setValue:menusArray forKey:@"menus"];
            }
            
            // 发送通知（当其model的值）
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:dataDic];
        } else if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
//            NSLog(@"%@",responseObject[@"data"]);
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
    
}

#pragma mark --传入网址，请求频道界面数据
+ (void)getDataSourceForChannelsWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"data"];
            
            //            NSLog(@"******* %@",array);
            for (NSDictionary *dic in array) {
                ChannelModel *model = [[ChannelModel alloc]initWithDic:dic];
                [dataSource addObject:model];
                
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            
            block(dataDic);
        } else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
}
#pragma mark --传入网址，请求子界面数据
+ (void)getDataSourceForSubWithURLStr:(NSString *)urlStr andParameters:(NSDictionary *)parameters withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSLog(@"%@ /n %@",urlStr,parameters);
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"list"]) {
                SubModel *model = [[SubModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            NSDictionary *dic = @{@"data":array};
            block(dic);
        } else {
//            NSLog(@"%@",responseObject[@"message"]);
            block(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
        
    }];
}
#pragma mark -- 传入网址，请求视频详情界面数据
+ (void)getDataSourceForDetailVideoWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject[@"data"];
            DetailVideoModel *model = [[DetailVideoModel alloc]initWithDic:dic];;
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:model forKey:@"data"];
            
            block(dataDic);
        } else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
    
}
#pragma mark 传入网址，获得字典
+ (void)getDataSourceWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject[@"data"];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dic forKey:@"data"];
            
            block(dataDic);
        } else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
}

#pragma mark -- 传入网址，获得评论信息
+ (void)getDataSourceForCommentWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *mapDic = responseObject[@"data"][@"page"][@"map"];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSNumber *userId in responseObject[@"data"][@"page"][@"list"]) {
                NSDictionary *dic = mapDic[[NSString stringWithFormat:@"c%@",userId]];
//                NSLog(@"++++++%@  %@",dic,userId);
                DetailVideoCommentModel *model = [[DetailVideoCommentModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"][@"page"]];
            [dataDic setValue:array forKey:@"map"];
            
            block(dataDic);
        } else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
}
#pragma mark -- 传入网址，获得视频相关信息
+ (void)getDataSourceForVideoAboutWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"page"][@"list"]) {
                DetailVideoAboutModel *model = [[DetailVideoAboutModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:array forKey:@"data"];
            
            block(dataDic);
        } else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
    }];
    
}
#pragma mark -- 传入网址，获得番剧详情相关信息
+ (void)getDataSourceForComicDetailWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
//        NSLog(@"%@",responseObject);
        if ( [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            
//            NSLog(@"%@",responseObject);
            
            ComicDetailModel *model = [[ComicDetailModel alloc]initWithDic:responseObject[@"data"]];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:model forKey:@"data"];
            
            block(dataDic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
        block(@{@"data":error});
//        NSLog(@"%@  error = %@",task,error);
    }];
    
    
}

@end
