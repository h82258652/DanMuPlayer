//
//  ComicInfoCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicInfoCollectionViewController.h"
#import "ComicDetailFirstCollectionViewCell.h"
#import "ComicDetailSecondCollectionViewCell.h"

@interface ComicInfoCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)ComicDetailModel *mainModel;  // 主model

@property (nonatomic,assign)BOOL showFirstSectionInfo;  // 是否展示第一个分区的全部信息

@end

@implementation ComicInfoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.showFirstSectionInfo = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicDetailFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comic_first_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicDetailSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comic_sencond_cell"];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 自定义方法
/** 赋值 */
- (void)setValueWithComicDetailModel:(ComicDetailModel *)model {
    
    self.mainModel = model;
    [self.collectionView reloadData];
    
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
    if (self.mainModel) {
        return 2;
    }
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
//        NSLog(@"%ld",self.mainModel.videoCount);
        return self.mainModel.videoCount;
        
    }
    
}
// 选择cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ComicDetailFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comic_first_cell" forIndexPath:indexPath];
        return cell;
    } else {
        ComicDetailSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comic_sencond_cell" forIndexPath:indexPath];
        return cell;
    }
    
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            [(ComicDetailFirstCollectionViewCell *)cell setValueWithModel:self.mainModel];
            
        }
            break;
        case 1:
        {
            ComicDetailVideoModel *videoModel = self.mainModel.videosArr[indexPath.item];
//            ((ComicDetailSecondCollectionViewCell *)cell).titleLabel.text = videoModel.title;
            [(ComicDetailSecondCollectionViewCell *)cell setValueWithTitle:videoModel.title];
            break;
        }
        default:
            break;
    }
    
}



#pragma mark <UICollectionViewDelegateFlowLayout>
// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (self.showFirstSectionInfo) {
            
            CGFloat height = [ComicDetailFirstCollectionViewCell heightOfCellWithStr:self.mainModel.intro];
            return CGSizeMake(kScreenWidth - 30 , height);
        } else {
            
            return CGSizeMake(kScreenWidth - 30, 140);
        }
    } else {
        
        return CGSizeMake((kScreenWidth - 40) / 2 , 30);
    }
    
    
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


#pragma mark <UICollectionViewDelegate>
// 选中了cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"选中了 %ld  %ld",indexPath.section,indexPath.item);
    
    if (indexPath.section == 0)
    {
        // 如果是点击了第一个分区，就隐藏或显示第一个分区的详细内容
        self.showFirstSectionInfo = !self.showFirstSectionInfo;
        [self.collectionView reloadData];
        
    } else
    {
        ComicDetailVideoModel *model = self.mainModel.videosArr[indexPath.item];
        self.changeVideoIdBlock(model.videoId);
    }
    
    
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
