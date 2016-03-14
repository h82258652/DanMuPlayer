//
//  ArticleSubChannelCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleSubChannelCollectionViewController.h"
#import "ArticleSubChannelCollectionHeaderReusableView.h"
#import "ArticleSubChannelCollectionViewCell.h"
#import "ArticleDetailViewController.h"
//#import "ArticleCollectionViewCell.h"

#import "DataHelper.h"

#import "RecommendCellModel.h"
#import "SubModel.h"

@interface ArticleSubChannelCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)RecommendModel *mainModel;
@property (nonatomic,assign)NSInteger index;  // 当前选中的btn

// 网址参数
@property (nonatomic,assign)NSInteger channelIds;  // 频道id
@property (nonatomic,assign)NSInteger pageNo;  // 页码
@property (nonatomic,assign)NSInteger pageSize;  // 每次请求数据量;
@property (nonatomic,assign)NSInteger sort;  // 排序类型
@property (nonatomic,assign)NSInteger range;  // 时间范围

@end

@implementation ArticleSubChannelCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
//    self.pageNo = 1;
//    self.pageSize = 20;
//    self.sort = 5;
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"article_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleSubChannelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"article_cell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleSubChannelCollectionHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 自定义方法
/** 加载数据 */
- (void)loadDateWithSubChannelId:(NSInteger)subChannelId
{
 
    self.channelIds = subChannelId;
    self.pageSize = 20;
    self.pageNo = 1;
    self.sort = 5;
    
    [self loadDataWithchannelIds:self.channelIds];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [dic setValue:@(self.channelIds) forKey:@"channelIds"];
//    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
//    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
//    [dic setValue:@(self.sort) forKey:@"sort"];
//    
//    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *dic)
//    {
//        self.dataSource = dic[@"data"];
//        NSLog(@"拿到了数据");
//    }];
}

- (void)loadDateWithModel:(RecommendModel *)model withIndex:(NSInteger)index
{
    self.mainModel = model;
    self.index = index;
    RecommendCellModel *cellModel = model.contents[index];
    
    self.channelIds = [cellModel.url integerValue];
    self.pageSize = 20;
    self.pageNo = 1;
    self.sort = 5;
    
    [self loadDataWithchannelIds:self.channelIds];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [dic setValue:@(self.channelIds) forKey:@"channelIds"];
//    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
//    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
//    [dic setValue:@(self.sort) forKey:@"sort"];
//    
//    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *dic)
//     {
//         self.dataSource = dic[@"data"];
//         NSLog(@"拿到了数据");
//         [self.collectionView reloadData];
//     }];
    
}
/** 请求数据 */
- (void)loadDataWithchannelIds:(NSInteger)channelIds
{
    self.channelIds = channelIds;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@(self.channelIds) forKey:@"channelIds"];
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
    [dic setValue:@(self.sort) forKey:@"sort"];
    
    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *dic)
     {
         if (self.pageNo == 1) {
             [self.dataSource removeAllObjects];
         }
         [self.dataSource addObjectsFromArray:dic[@"data"]];
//         NSLog(@"拿到了数据");
         [self.collectionView reloadData];
     }];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

// 加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleSubChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"article_cell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubModel *model = self.dataSource[indexPath.item];
    
    [(ArticleSubChannelCollectionViewCell *)cell setValueWithSubModel:model];
}
// 选择页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ArticleSubChannelCollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView setNowSubChannelWithchannelId:self.channelIds];
        __weak typeof(self)weakSelf = self;
        headerView.changeSubChannelBlock = ^(NSInteger index) {
          
//            RecommendCellModel *model = self.mainModel.contents[index];
            self.pageNo = 1;
//            NSLog(@"%@",self.mainModel.name);
//            NSLog(@"%@",self.mainModel.contents);
//            NSLog(@"***%ld",[model.url integerValue]);
            [weakSelf loadDataWithchannelIds:index];
            
        };
        
        
        return headerView;
    }
    return nil;
}


#pragma mark <UICollectionViewDelegateFlowLayout>
// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth - 10, 55);
}
// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth - 4, 50);
}
// cell的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark <UICollectionViewDelegate>
// 选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SubModel *subModel = self.dataSource[indexPath.item];
    ArticleDetailViewController *articleVC = [[ArticleDetailViewController alloc]initWithNibName:@"ArticleDetailViewController" bundle:nil];
//    NSLog(@"%@",subModel.contentId);
    NSString *str = [subModel.contentId substringFromIndex:2];
    [articleVC loadDataWithArticleId:[str integerValue]];
    [self.navigationController pushViewController:articleVC animated:YES];
    
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
