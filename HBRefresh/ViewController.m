//
//  ViewController.m
//  HBRefresh
//
//  Created by denghb on 02/02/2018.
//  Copyright © 2018 denghb. All rights reserved.
//

#define mScreenWidth  [UIScreen mainScreen].bounds.size.width
#define mScreenHeight [UIScreen mainScreen].bounds.size.height
#define mStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#import "ViewController.h"
#import "UIScrollView+HBRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray<NSString *> *_data;
    int _page;
    int _totalPage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTitle:@"HBRefresh"];
    
    _totalPage = 3;// 总页数
    _data = [NSMutableArray<NSString *> array];
    
    // 导航栏（navigationbar）
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;  // 高度
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mStatusHeight - navHeight)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setHb_header:[HBRefreshHeader initWithTarget:self action:@selector(pull)]];
    [_tableView setHb_footer:[HBRefreshFooter initWithTarget:self action:@selector(load)]];
    [self.view addSubview:_tableView];
    
    // 
    [_tableView.hb_header beginRefreshing];
}

- (void)pull
{
    _page = 1;
    [_data removeAllObjects];
    [self request];
}

- (void)load
{
    [self request];
}

- (void)request
{
    NSLog(@"request page (%u)", _page);
    // 模拟响应
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(response) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)response
{
    NSLog(@"response page (%u)", _page);
    
    for (int i = 0; i < 20; i++) {
        [_data addObject:[NSString stringWithFormat:@"cell %u", (arc4random() % 10)]];
    }
    
    if (++_page > _totalPage) {
        _tableView.hb_footer.hidden = YES;
    } else {
        _tableView.hb_footer.hidden = NO;
    }
    [_tableView.hb_header endRefreshing];
    [_tableView.hb_footer endRefreshing];
    [_tableView reloadData];
}

#pragma -mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    NSInteger row = indexPath.row;
    if (row < _data.count) {
        [cell.textLabel setText:_data[row]];
    }
    
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
