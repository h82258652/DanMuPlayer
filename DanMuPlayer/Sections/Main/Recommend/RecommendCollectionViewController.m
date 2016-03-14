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

#import "SubViewController.h"
#import "DetailVideoViewController.h"
#import "ComicDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "ArticleSubChannelCollectionViewController.h"

#import "MJRefresh.h"


@interface RecommendCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSoruce; // 数据源
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *defaultFlowLayout;

@end

@implementation RecommendCollectionViewController

//static NSString * const nameOfMessage = @"changeModelOfRecommend";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化参数
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
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
    

    
}
/** 为网址赋值，触发网络请求 */
- (void)setMainURLStr:(NSString *)mainURLStr {
    
//    NSLog(@"设置");
    
    if (_mainURLStr != mainURLStr) {
        _mainURLStr = nil;
        _mainURLStr = [mainURLStr copy];
    }
    // 注册接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:self.mainURLStr object:nil];  // 请求到新的数据
    
    // 请求数据
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    
//    NSLog(@"%@",self.mainURLStr);
    
    [DataHelper getDataSourceForCommendWithURLStr:self.mainURLStr withName:self.mainURLStr withBlock:^(NSDictionary *dic) {
        
//        [self.collectionView.mj_header performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
        [self.collectionView.mj_header endRefreshing];
        
        
        
        if ([dic[@"data"] isKindOfClass:[NSString class]] || [dic[@"data"] isKindOfClass:[NSError class]]) {
            
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
        } else {
            
            self.dataSoruce = [NSMutableArray arrayWithArray:dic[@"dataArray"]];
            
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        
    }];
    
}
/** dismiss alert */
- (void)dismissAlert:(NSTimer *)timer {
    
    UIAlertController *alert = timer.userInfo[@"alert"];
    [alert dismissViewControllerAnimated:YES completion:nil];
    
}


/** 下拉刷新 */
- (void)refreshPage {
    
    [self.dataSoruce removeAllObjects];
    
    [self loadData];
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
    
    for (RecommendModel *model in self.dataSoruce) {
        if (model.recommend_id == [dic[@"model_id"] integerValue]) {
            model.contents = dic[@"dataArray"];
            
            if (dic[@"menus"]) {
                model.menus = dic[@"menus"];
            }
//            NSLog(@"%@",model.menus.firstObject);
            // 刷新界面
            [self.collectionView reloadData];
        }
    }
}
// 当轮播图被点击时，触发事件
//- (void)rollPlayViewDidSelect:(NSNotification *)sender {
//    NSIndexPath *indexPath = sender.userInfo[@"indexPath"];
//    
//    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
//}



#pragma mark <UICollectionViewDelegateFlowLayout>

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    
//    NSLog(@"***%ld",model.type_id);
    
    // 根据不同的类型设置分区页眉是否显示
    switch (model.type_id) {
        case 19:
        case 1:  // 视频
            return CGSizeMake((kScreenWidth - 5 * 4) / 2, kScreenWidth / 2.5);
            break;
        case 2:  // 文章
            if (kScreenWidth * 5 / 19 < 90) {
                return CGSizeMake(kScreenWidth - 20, 90);
            }
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
                return CGSizeMake((kScreenWidth - 20)/ 2, kScreenWidth * 4.5 / 19);
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
//    NSLog(@"cell大小为0");
    return CGSizeMake(50, 50);
    
}

// cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    RecommendModel *model = self.dataSoruce[section];
    
    if (model.type_id == 5) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    
    // 分区页眉是否显示
    if (model.showName == 1 || model.type_id == 1 || model.type_id == 4) {
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
    } else if (model.type_id == 6) {
        return 0;
    }
    return [model.contents count];
}


// 选取不同的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    
//    NSLog(@"***** %ld",model.type_id);
    // 判断使用哪种cell
    switch (model.type_id) {
        case 19:
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
//            BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCell" forIndexPath:indexPath];
//            return cell;
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
    if ([cell isKindOfClass:[RollPlayCollectionViewCell class]]) {  // 轮播图
        
        [(RollPlayCollectionViewCell *)cell setValueWithModel:model];
        ((RollPlayCollectionViewCell *)cell).didSelectImageViewBlock = ^(NSIndexPath *index) {
            
            [self collectionView:self.collectionView didSelectItemAtIndexPath:index];
            
        };
        
    } else if ([cell isKindOfClass:[VideoCollectionViewCell class]]) {  // 视频
        
        [(VideoCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[BannerCollectionViewCell class]]) {  // 横幅
        
        [(BannerCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ComicCollectionViewCell class]]) {  // 番剧
        
        [(ComicCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ArticleCollectionViewCell class]]) {  // 文章
        
        [(ArticleCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[SortCollectionViewCell class]]) {  // 排行榜
        
        [(SortCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[UpCollectionViewCell class]]) {  // up主
        
        [(UpCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
    } else if ([cell isKindOfClass:[ChannelCollectionViewCell class]]) {  // 频道
        
        [(ChannelCollectionViewCell *)cell setValueWithMainModel:model];
        // 设置block触发事件
        [(ChannelCollectionViewCell *)cell setSubChannelBlock:^(NSDictionary *dic){
           
            RecommendModel *rModel = dic[@"model"];
            NSInteger index = [dic[@"index"] integerValue];
//            NSLog(@"%ld",model.type_id);
            if (rModel.channelId == 63) {
                
                // 文章子分区
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
                ArticleSubChannelCollectionViewController *subVC = [[ArticleSubChannelCollectionViewController alloc]initWithCollectionViewLayout:layout];
                subVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
                [subVC loadDateWithModel:rModel withIndex:index];
                //            NSLog(@"%@",rModel.contents);
                [self.navigationController pushViewController:subVC animated:YES];
            } else {
                
                // 在次级界面调整
                UIStoryboard *substoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
                SubViewController *subVC = [substoryboard instantiateViewControllerWithIdentifier:@"sub_main_vc"];
                subVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
                
                [subVC setUpWithRecommendModel:rModel withCustomIndex:index];
                [self.navigationController pushViewController:subVC animated:YES];
            }
            
            
            
            
        }];
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
            case 19:
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
            [(ChannelFooterCollectionReusableView *)view setTitleOfFooter:[footerModel valueForKey:@"name"] withSection:indexPath.section];
//            [(ChannelFooterCollectionReusableView *)view setNameOfMessage:[NSString stringWithFormat:@"footer%@",self.mainURLStr]];
            [(ChannelFooterCollectionReusableView *)view setClickFooterBlock:^(NSInteger section){
//                NSLog(@"点击了%ld",section);
                RecommendModel *model = self.dataSoruce[section];
                
                if (model.channelId == 155 || model.channelId == 60 || model.channelId == 63) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeContentOffset" object:nil userInfo:@{@"channel_Id":@(model.channelId)}];
                } else {
                    
                    static dispatch_once_t oneToken;
                    dispatch_once(&oneToken, ^{
                        // 注册成为接收 频道 model消息的观察者
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelModel:) name:@"getChannelModel" object:nil];
                    });
                    
                    // 发送通知，要求 频道 界面提供对应的model
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"giveChannelModelToRecommendFooter" object:nil userInfo:@{@"channel_Id":@(model.channelId)}];
                }
                
            }];
        }
    }
    
}
// 注册成为接收 频道 model消息的观察者
- (void)getChannelModel:(NSNotification *)sender {
    
    ChannelModel *model = sender.userInfo[@"model"];
    [self goToSubPage:model withStartIndex:-1];
    
}


/** 跳转子分区 */
- (void)goToSubPage:(id)model withStartIndex:(NSInteger)startIndex {
    // 在次级界面调整
    UIStoryboard *substoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    SubViewController *subVC = [substoryboard instantiateViewControllerWithIdentifier:@"sub_main_vc"];
    subVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    
    if ([model isKindOfClass:[RecommendModel class]]) {
        
        [subVC setUpWithRecommendModel:model withCustomIndex:startIndex];
    } else {
        [subVC setUpWithChannelModel:model WithCustomIndex:startIndex];
    }
    
    [self.navigationController pushViewController:subVC animated:YES];
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"*****%ld,%ld",indexPath.section,indexPath.item);
    
    
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    RecommendCellModel *subModel = model.contents[indexPath.item];
//    NSLog(@"%ld",model.type_id);
    switch (model.type_id) {
        case 19:
        case 1:
        case 5:
        case 12:
        {
            
            // 视频播放界面
            UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
            DetailVideoViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"detail_Video"];
            [subVC loadDataWithVideoId:[subModel.url integerValue]];
//            [self.navigationController pushViewController:subVC animated:NO];
            [self presentViewController:subVC animated:YES completion:nil];
            
            break;
        }
        case 3:
        {
            UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
            ComicDetailViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"comic_detail"];
//            NSLog(@"%ld",[subModel.url integerValue]);
            [subVC loadDataWithBangumisId:[subModel.url integerValue]];
//            [self.navigationController pushViewController:subVC animated:NO];
            [self presentViewController:subVC animated:YES completion:nil];
            
            break;
        }
        case 2:
        {
            
            ArticleDetailViewController *articleVC = [[ArticleDetailViewController alloc]initWithNibName:@"ArticleDetailViewController" bundle:nil];
            [articleVC loadDataWithArticleId:[subModel.url integerValue]];
            [self.navigationController pushViewController:articleVC animated:YES];
            break;
        }
        default:
            break;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 状态栏切换
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = kThemeColor;
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
