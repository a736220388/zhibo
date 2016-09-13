//
//  HotViewController.m
//  ZHIBO
//
//  Created by qianfeng on 16/9/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "HotViewController.h"
#import "NetWorkEngine.h"
#import "PlayerModel.h"
#import "PlayerTableViewCell.h"
#import "Masonry.h"
#import "ODRefreshControl.h"
#import "PlayerViewController.h"

//映客接口
#define MainData [NSString stringWithFormat:@"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"]
#define Ratio 618/480
@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tbView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HotViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    
    //下拉刷新
    [self addRefresh];
    
    //加载数据
    [self loadData];
}
#pragma mark ---- <加载数据>
- (void)loadData{
    [self.dataArray removeAllObjects];
    __weak __typeof(self)vc = self;
    NetWorkEngine *netWork = [[NetWorkEngine alloc]init];
    [netWork AfJSONGetRequest:MainData];
    netWork.successfulBlock = ^(id object){
        NSArray *listArray = [object objectForKey:@"lives"];
        for (NSDictionary *dic in listArray) {
            PlayerModel *playerModel = [[PlayerModel alloc]initWithDictionary:dic];
            playerModel.city = dic[@"city"];
            playerModel.portrait = dic[@"creator"][@"portrait"];
            playerModel.name = dic[@"creator"][@"nick"];
            playerModel.online_users = [dic[@"online_users"] intValue];
            playerModel.url = dic[@"stream_addr"];
            [vc.dataArray addObject:playerModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.tbView reloadData];
        });
    };
}
#pragma mark ---- <下拉刷新>
- (void)addRefresh{
    ODRefreshControl *refreshController = [[ODRefreshControl alloc]initInScrollView:self.tbView];
    [refreshController addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
}
- (void)refreshAction:(ODRefreshControl *)refreshController{
    double delayInSecinds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecinds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [refreshController endRefreshing];
        [self loadData];
    });
}

#pragma mark ---- <setupTableView>
- (void)setupTableView{
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 105);
    self.tbView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = [UIScreen mainScreen].bounds.size.width * Ratio + 1;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbView];
}
#pragma mark ---- <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 0;
    }
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"playerCellId";
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlayerTableViewCell" owner:nil options:nil] lastObject];
    }
    PlayerModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark ---- <点击跳转>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerModel * playerModel = self.dataArray[indexPath.row];
    PlayerViewController *playerCtrl = [[PlayerViewController alloc]init];
    playerCtrl.liveUrl = playerModel.url;
    playerCtrl.imageUrl = playerModel.portrait;
    [self.navigationController pushViewController:playerCtrl animated:true];
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    //transition.subtype = kCATransitionFromLeft;//可更改为其他方式
//    transition.duration=0.2;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController pushViewController:playerCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
