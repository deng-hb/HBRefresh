//
//  ViewController.m
//  HBRefresh
//
//  Created by denghb on 02/02/2018.
//  Copyright © 2018 denghb. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+HBRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray<NSString *> *_data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTitle:@"HBRefresh"];
    
    [self mock];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setHb_header:[HBRefreshHeader initWithTarget:self action:@selector(request)]];
    [self.view addSubview:_tableView];
}

- (void)mock
{
    _data = [NSMutableArray<NSString *> array];
    
    for (int i = 0; i < 10; i++) {
        [_data addObject:[NSString stringWithFormat:@"cell %u", (arc4random() % 10)]];
    }
}

- (void)request
{
    NSLog(@"request");
    // 模拟响应
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(response) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)response
{
    NSLog(@"response");
    
    [self mock];
    
    [_tableView.hb_header endRefreshing];
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
    
    [cell.textLabel setText:_data[indexPath.row]];
    
    return cell;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
