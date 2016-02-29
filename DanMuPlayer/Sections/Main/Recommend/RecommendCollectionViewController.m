//
//  RecommendCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RecommendCollectionViewController.h"
#import "RollPlayCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
#import "ComicCollectionViewCell.h"
#import "ArticleCollectionViewCell.h"
#import "SortCollectionViewCell.h"
#import "UpCollectionViewCell.h"
#import "ChannelCollectionViewCell.h"
#import "DataHelper.h"

#import "RecommendCollectionReusableView.h"  // 页眉
#import "ChannelFooterCollectionReusableView.h"  // 页脚

#import "RecommendModel.h"
#import "RecommendCellModel.h"

#import "FooterModel.h"


@interface RecommendCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSoruce; // 数据源
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *defaultFlowLayout;

@end

@implementation RecommendCollectionViewController

//static NSString * const nameOfMessage = @"changeModelOfRecommend";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSoruce = [NSMutableArray arrayWithCapacity:1];
    
    // 注册cell
    [self.collectionView registerClass:[RollPlayCollectionViewCell class] forCellWithReuseIdentifier:@"rollCell"];  // 轮播cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"]; // 视频cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"BannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCell"]; // 横幅cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comicCell"];  // 番剧cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"articleCell"];  // 文章cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SortCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sortCell"];  // 排行榜cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"UpCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"upCell"];  // up主cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChannelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"channelCell"];  // 频道cell
    
    // 注册页眉页脚
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChannelFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"yuan"];
    
    // 注册接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:self.mainURLStr object:nil];  // 请求到新的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rollPlayViewDidSelect:) name:@"tapImage" object:nil]; // 轮播图被点击
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFooterView:) name:@"recommend_footer" object:nil];
    
#warning stop loadData ****************
    // 请求数据
//    [self loadData];
    
}

- (void)setMainURLStr:(NSString *)mainURLStr {
    if (_mainURLStr != mainURLStr) {
        _mainURLStr = [mainURLStr copy];
    }
    // 请求数据
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    
    dispatch_queue_t queue = dispatch_queue_create("com.recommend.loadData", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [DataHelper getDataSourceForCommendWithURLStr:self.mainURLStr withName:self.mainURLStr withBlock:^(NSDictionary *dic) {
            self.dataSoruce = [NSMutableArray arrayWithArray:dic[@"dataArray"]];
//            NSLog(@"%@",[NSThread currentThread]);
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }];
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 其他方法
// 当请求到新的内容时，刷新界面
- (void)changeModel:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    
//    NSLog(@"请求到新的数据");
    
    for (RecommendModel *model in self.dataSoruce) {
        if (model.recommend_id == [dic[@"model_id"] integerValue]) {
            model.contents = dic[@"dataArray"];
            
            if (dic[@"menus"]) {
                model.menus = dic[@"menus"];
            }
//            NSLog(@"%@",model.menus.firstObject);
        }
        // 刷新界面
        [self.collectionView reloadData];
    }
}
// 当轮播图被点击时，触发事件
- (void)rollPlayViewDidSelect:(NSNotification *)sender {
    NSIndexPath *indexPath = sender.userInfo[@"indexPath"];
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
/** 页脚被点击时触发方法 */
//- (void)didSelectFooterView:(NSNotification *)sender {
//    NSLog(@"页脚被点击");
//}



#pragma mark <UICollectionViewDelegateFlowLayout>

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    // 根据不同的类型设置分区页眉是否显示
    switch (model.type_id) {
        case 1:  // 视频
            return CGSizeMake((kScreenWidth - 5 * 4) / 2, kScreenWidth / 2.5);
            break;
        case 2:  // 文章
            return CGSizeMake(kScreenWidth - 20, kScreenWidth * 5 / 19);
            break;
        case 3:  // 番剧
            return CGSizeMake((kScreenWidth - 6 * 6 ) / 3, kScreenWidth * 3 / 5);
            break;
        case 4: // up主
            return CGSizeMake(kScreenWidth - 10, 50);
            break;
        case 5:  // 轮播图
            return CGSizeMake(kScreenWidth, kScreenWidth * 8 / 19);
            break;
        case 6:  // 横幅
            
            if (model.contents.count == 2) {
                return CGSizeMake((kScreenWidth - 10)/ 2, kScreenWidth * 4.5 / 19);
                break;
            }
            
            return CGSizeMake(kScreenWidth - 10, kScreenWidth * 4.5 / 19);
            break;
        case 7:  // 频道
            return CGSizeMake(kScreenWidth - 10, 100);
        case 12:  // 排行榜
            return CGSizeMake(kScreenWidth - 20, kScreenWidth * 5 / 19);
            break;
        default:
            break;
    }
    NSLog(@"cell大小为0");
    return CGSizeZero;
    
}

// cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    
    // 分区页眉是否显示
    if (model.showName == 1) {
        return CGSizeMake(0, 50);
    }
    return CGSizeZero;
}
// 页脚的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    if (model.showMore == 1) {
        return CGSizeMake(kScreenWidth, 50);
    }
    return CGSizeZero;
}

#pragma mark <UICollectionViewDataSource>

// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSoruce.count;
}

// cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    
    if (model.type_id == 5 || model.type_id == 7) {  // 当为轮播图分区时，强制设置cell数为1
        return 1;
    }
    return model.contentCount;
}


// 选取不同的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    
//    NSLog(@"***** %ld",model.type_id);
    // 判断使用哪种cell
    switch (model.type_id) {
        case 1: {
            VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 2: {
            ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"articleCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 3: {
            ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 4: {
            UpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 5:{
            RollPlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rollCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 6: {
            BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 7: {
            ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
            return cell;
            break;
        }
        case 12: {
            SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sortCell" forIndexPath:indexPath];
            return cell;
            break;}
        default:
            break;
    }
    
    return nil;
}
// 为即将显示在界面上的cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendModel *model = self.dataSoruce[indexPath.section];
    
    
    
    // 根据不同种类的cell，调用不同的cell
    if ([cell isKindOfClass:[RollPlayCollectionViewCell class]]) {
        
        [(RollPlayCollectionViewCell *)cell setValueWithModel:model];
        
    } else if ([cell isKindOfClass:[VideoCollectionViewCell class]]) {
        
        [(VideoCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[BannerCollectionViewCell class]]) {
        
        [(BannerCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ComicCollectionViewCell class]]) {
        
        [(ComicCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ArticleCollectionViewCell class]]) {
        
        [(ArticleCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[SortCollectionViewCell class]]) {
        
        [(SortCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[UpCollectionViewCell class]]) {
        
        [(UpCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
    } else if ([cell isKindOfClass:[ChannelCollectionViewCell class]]) {
        
        [(ChannelCollectionViewCell *)cell setValueWithMainModel:model];
//        NSLog(@"%@",model.name);
    }
}
// 设置页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
//    NSLog(@"改改改");
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        RecommendCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        ChannelFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footerView;
    }
    
    return nil;
}

// 为页眉页脚赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    RecommendModel *model = self.dataSoruce[indexPath.section];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {  // 页眉
        
        switch (model.type_id) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 12:
                [(RecommendCollectionReusableView *)view setValueWithModel:model];
                break;
            case 5:{
                
                break;}
            case 6: {
                
                break;}
            case 7: {
                
                break;
            }
            default:
                break;
        }
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {  // 页脚
        // 为页脚赋值
        if (model.menus.count > 0) {
            FooterModel *footerModel = [model.menus firstObject];
//            NSLog(@"%@",[model.menus firstObject]);
//            NSLog(@"%ld",footerModel.regionId);
//            NSLog(@"%@",[footerModel valueForKey:@"name"]);
            [(ChannelFooterCollectionReusableView *)view setTitleOfFooter:[footerModel valueForKey:@"name"] withSection:indexPath.section];
//            [(ChannelFooterCollectionReusableView *)view setNameOfMessage:[NSString stringWithFormat:@"footer%@",self.mainURLStr]];
            [(ChannelFooterCollectionReusableView *)view setClickFooterBlock:^(NSInteger section){
                NSLog(@"点击了%ld",section);
            }];
        }
    }
    
}




#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"*****%ld,%ld",indexPath.section,indexPath.item);
    
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
