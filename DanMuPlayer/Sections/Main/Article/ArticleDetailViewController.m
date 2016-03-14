//
//  ArticleViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import <WebKit/WebKit.h>
#import "DataHelper.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ArticleEntity.h"

#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]


@interface ArticleDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 标题
@property (weak, nonatomic) IBOutlet UILabel *upLabel;  // up主
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  // 时间
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;  // 照片
@property (weak, nonatomic) IBOutlet UILabel *bananaLabel;  // 香蕉数
@property (weak, nonatomic) IBOutlet UILabel *readLabel; // 阅读数
//@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *infoView; // 信息视图

@property (nonatomic,assign)NSInteger articleId;  // 文章id
@property (nonatomic,strong)ArticleModel *mainModel;  // 主model


@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.photoImageView.layer.cornerRadius = CGRectGetHeight(self.photoImageView.frame) / 2;
    self.photoImageView.layer.masksToBounds = YES;
    
    
    // 判断是否收藏过，添加收藏按钮
    [self whetherCollection];
    
}

#pragma mark - 自定义方法
/** 赋值 */
- (void)loadDataWithArticleId:(NSInteger)articleId
{
    self.articleId = articleId;
    NSString *urlStr = [NSString stringWithFormat:kArticleDetailURLStr,(long)articleId];
//    NSLog(@"%@",urlStr);
    [DataHelper getDataSourceWithURLStr:urlStr withBlock:^(NSDictionary *dic)
    {
        // 拿到的数据，封装成model
        self.mainModel = [[ArticleModel alloc]initWithDic:dic[@"data"]];
//        NSLog(@"拿到了model");
        // 赋值
        [self setValue];
    }];
    
    
}
/** 赋值 */
- (void)setValue
{
    self.titleLabel.text = self.mainModel.title;
    self.upLabel.text = self.mainModel.owner_name;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.mainModel.releaseDate / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"发布于%@",timeStr];
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.mainModel.owner_avatar]];
    
    NSInteger bananaNum = [self.mainModel.visit[@"goldBanana"] integerValue];
    self.bananaLabel.text = bananaNum >= 10000 ? [NSString stringWithFormat:@"%ld万",bananaNum / 10000] : [NSString stringWithFormat:@"%ld",bananaNum];
    
    NSInteger views = [self.mainModel.visit[@"views"] integerValue];
    self.readLabel.text = views >= 10000 ? [NSString stringWithFormat:@"%ld万",views / 10000] : [NSString stringWithFormat:@"%ld",views];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.infoView.bounds];
    [self.infoView addSubview:webView];
    [webView loadHTMLString:self.mainModel.article_content baseURL:nil];
}
/** 判断是否收藏过，添加收藏按钮 */
- (void)whetherCollection
{
    
    // 添加收藏按钮
//    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_action"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionArticle)];
//    self.navigationItem.rightBarButtonItem = collectionItem;
    
    if ([self selectCoreDataWithId:self.articleId]) {  // 已收藏
//        NSLog(@"已收藏");
        // 添加已收藏按钮
        UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_did"] style:UIBarButtonItemStylePlain target:self action:@selector(didCollection)];
        self.navigationItem.rightBarButtonItem = collectionItem;
    } else {  // 未收藏
//        NSLog(@"未收藏");
        // 添加收藏按钮
        UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_action"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionArticle)];
        self.navigationItem.rightBarButtonItem = collectionItem;
    }
    
    
    
}


/** 收藏文章 */
- (void)collectionArticle
{
    
//    NSLog(@"收藏文章");
    
    // 1.创建描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ArticleEntity" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    // 2.创建学生
    ArticleEntity *article = [[ArticleEntity alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:[kAppDelegate managedObjectContext]];
    // 3.赋值
    article.title = self.mainModel.title;
//    NSLog(@"%ld,%@",self.articleId,@(self.articleId));
    article.articleId = [NSNumber numberWithInteger:self.articleId];
    article.views = @([self.mainModel.visit[@"views"] integerValue]);
    article.up = self.mainModel.owner_name;
    
//    NSLog(@"**%@",[NSNumber numberWithInteger:self.articleId]);
    // 4.保存在真正的数据库中
    NSError *error = nil;
    [[kAppDelegate managedObjectContext] save:&error];
    if (error) {
//        NSLog(@"保存失败");
    } else {
//        NSLog(@"保存成功");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"collection_did"];
        self.navigationItem.rightBarButtonItem.action = @selector(didCollection);
    }
    
}
/** 查询数据库 */
- (BOOL)selectCoreDataWithId:(NSInteger)articleId
{
    // 创建请求体
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ArticleEntity"];
    // 执行查询，获取结果
    NSArray *requestArr = [[kAppDelegate managedObjectContext] executeFetchRequest:request error:nil];
//    NSLog(@"%@",requestArr);
    for (ArticleEntity *article in requestArr) {
//        NSLog(@"***** %@,%@",article.articleId,[NSNumber numberWithInteger:articleId]);
        if ([article.articleId  isEqual: [NSNumber numberWithInteger:articleId]]) {
//            NSLog(@"aaa");
            return YES;
        }
    }
    
    return NO;
}

/** 提示已收藏 */
- (void)didCollection {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
//    NSLog(@"已经收藏过了");
}
- (void)dismissAlert:(NSTimer *)timer
{
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

@end
