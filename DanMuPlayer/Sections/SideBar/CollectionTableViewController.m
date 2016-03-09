//
//  CollectionTableViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "CollectionTableViewController.h"
#import "CollectionTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "AppDelegate.h"

#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface CollectionTableViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源

@end

@implementation CollectionTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"article_cell"];
    
    // 编辑
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView setEditing:YES animated:YES];
    
    // 配置导航栏
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navi_back"]];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [imageView addSubview:btn];
    [btn addTarget:self action:@selector(backBeforePage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
    
    // 从coredata读取数据
    [self loadDataFromCoreData];
}

/** 从coredata读取数据 */
- (void)loadDataFromCoreData
{
    
    [self selectCoreData];
    
}
/** 查询 */
- (void)selectCoreData
{

    
    // 创建请求体
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ArticleEntity"];
    // 执行查询，获取结果
    NSArray *requestArr = [[kAppDelegate managedObjectContext] executeFetchRequest:request error:nil];
    
    if (requestArr.count > 0) {
        [self.dataSource addObjectsFromArray:requestArr];
        [self.tableView reloadData];
    }

}

/** 删除 */
- (void)deleteOneArticle:(ArticleEntity *)article {
    
    // 删除
    [[kAppDelegate managedObjectContext] deleteObject:article];
    
    // 执行保存操作，把修改操作影响到真实数据库
    [kAppDelegate saveContext];
    
    
    // 刷新
//    [self.tableView reloadData];
}

/** 返回上一页 */
- (void)backBeforePage
{
//    NSLog(@"返回上一页");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteOneArticle:self.dataSource[indexPath.row]];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"article_cell" forIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ArticleEntity *article = self.dataSource[indexPath.row];
    [(CollectionTableViewCell *)cell setValueWithArticleEntity:article];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleEntity *article = self.dataSource[indexPath.row];
    ArticleDetailViewController *articleVC = [[ArticleDetailViewController alloc]initWithNibName:@"ArticleDetailViewController" bundle:nil];
    [articleVC loadDataWithArticleId:[article.articleId integerValue]];
    
    [self.navigationController pushViewController:articleVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
