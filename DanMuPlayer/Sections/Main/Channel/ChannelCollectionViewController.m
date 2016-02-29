//
//  ChannelCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelCollectionViewController.h"
#import "ChannelFooterCollectionReusableView.h"
#import "ChannelHeaderCollectionReusableView.h"
#import "ChannelCollectionViewCell.h"
#import "DataHelper.h"

#import "ChannelModel.h"
#import "ChannelSubModel.h"

@interface ChannelCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源

@property (nonatomic,copy)NSString *nameOfMessage;  // 通知的名字

@end

@implementation ChannelCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    
    self.nameOfMessage = @"clickMoreChannel";
    
    // 注册成为观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectSubCell:) name:@"clickSubChannel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectMore:) name:self.nameOfMessage object:nil];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChannelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"channelCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChannelFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    // Do any additional setup after loading the view.
    
#warning -- need *****************
    // 请求数据
//    [self loadData];
    
    
}

#pragma mark - 自定义方法

/** 开始请求数据 */

- (void)setMainURLStr:(NSString *)mainURLStr {
    if (_mainURLStr != mainURLStr) {
        _mainURLStr = [mainURLStr copy];
    }
    [self loadData];
}

/** 请求数据 */
- (void)loadData {
    dispatch_queue_t queue = dispatch_queue_create("com.channels.loadData", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [DataHelper getDataSourceForChannelsWithURLStr:kChannelsURLStr withBlock:^(NSDictionary *dic) {
            self.dataSource = [NSMutableArray arrayWithArray:dic[@"dataArray"]];
//            NSLog(@"%@",[NSThread currentThread]);
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }];
    });
    
}
/** 选中了子频道 */
- (void)didSelectSubCell:(NSNotification *)sender {
    
#warning need completion****************
    
    ChannelSubModel *model = sender.userInfo[@"model"];
    NSLog(@"子频道");
    
}
/** 选中更多内容 */
- (void)didSelectMore:(NSNotification *)sender {
    NSInteger section = [sender.userInfo[@"section"] integerValue];
//    NSLog(@"%ld",[sender.userInfo[@"section"] integerValue]);
    ChannelModel *model = self.dataSource[section];
#warning need go next VC *********************
    
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
// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelModel *model = self.dataSource[indexPath.section];
    
    if ([cell isKindOfClass:[ChannelCollectionViewCell class]]) {
        [(ChannelCollectionViewCell *)cell setValueWithModel:model];
    }
    
}

// 页眉页脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ChannelHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ChannelFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
    
}
// 为页眉页脚赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    ChannelModel *model = self.dataSource[indexPath.section];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        [(ChannelHeaderCollectionReusableView *)view setTitleOfHeader:model.name];
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        [(ChannelFooterCollectionReusableView *)view setTitleOfFooter:[NSString stringWithFormat:@"%@推荐",model.name] withSection:indexPath.section];
//        [(ChannelFooterCollectionReusableView *)view setNameOfMessage:self.nameOfMessage];
        [(ChannelFooterCollectionReusableView *)view setClickFooterBlock:^(NSInteger section){
            NSLog(@"点击了%ld",section);
        }];
    }
}




#pragma mark <UICollectionViewDelegateFlowLayout>

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, kScreenWidth * 5 / 16);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 50);
}




#pragma mark <UICollectionViewDelegate>




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
