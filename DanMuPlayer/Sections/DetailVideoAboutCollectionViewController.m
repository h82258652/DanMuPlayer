//
//  DetailVideoAboutCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoAboutCollectionViewController.h"
#import "DataHelper.h"
#import "DetailVideoViewController.h"

#import "VideoCollectionViewCell.h"
#import "MJRefresh.h"

@interface DetailVideoAboutCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign)NSInteger pageNo;  // 页码
@property (nonatomic,assign)NSInteger videoId;  // 视频id

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源

@end

@implementation DetailVideoAboutCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    self.pageNo = 1;
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.collectionView.backgroundColor = kBGColor;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_about"];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithVideoId:self.videoId];
    }];
}

#pragma mark - 自定义方法
/** 请求数据 */
- (void)loadDataWithVideoId:(NSInteger)videoId {
    
    NSString *urlStr = [NSString stringWithFormat:kVideoAboutURLStr,(long)videoId,self.pageNo];
    [DataHelper getDataSourceForVideoAboutWithURLStr:urlStr withBlock:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        if ([dic[@"data"] isKindOfClass:[NSString class]] || [dic[@"data"] isKindOfClass:[NSError class]]) {
            
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
            
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:dic[@"data"]];
            [self.collectionView reloadData];
        }
        
    }];
}
/** dismiss alert */
- (void)dismissAlert:(NSTimer *)timer {
    
    UIAlertController *alert = timer.userInfo[@"alert"];
    [alert dismissViewControllerAnimated:YES completion:nil];
    
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_about" forIndexPath:indexPath];
    
    
    
    return cell;
}
// 给cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailVideoAboutModel *model = self.dataSource[indexPath.row];
    
    [(VideoCollectionViewCell *)cell setValueWithAboutModel:model];
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>
// cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth - 5 * 4) / 2, kScreenWidth / 2.5);;
}
// cell边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.changeVideoIdBlock) {
        self.changeVideoIdBlock(0);
    }
    
    DetailVideoAboutModel *model = self.dataSource[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    DetailVideoViewController *videoVC = [storyboard instantiateViewControllerWithIdentifier:@"detail_Video"];
    NSString *str = [model.contentId substringFromIndex:2];
    [videoVC loadDataWithVideoId:[str integerValue]];
    
//    NSLog(@"%@",str);
    
//    [self.navigationController pushViewController:videoVC animated:YES];
    [self presentViewController:videoVC animated:YES completion:nil];
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
