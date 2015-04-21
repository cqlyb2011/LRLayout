//
//  TestViewController.m
//  LRLayoutDemo
//
//  Created by LiYeBiao on 15/4/14.
//  Copyright (c) 2015年 GaoJing Electric Co., Ltd. All rights reserved.
//

#import "TestViewController.h"


@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,568) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    view1.backgroundColor = UIColor.greenColor;
    view1.layer.borderColor = UIColor.blackColor.CGColor;
    view1.layer.borderWidth = 2;
    [self.view addSubview:view1];
    
//    UIView *view2 = UIView.new;
//    view2.backgroundColor = UIColor.redColor;
//    view2.layer.borderColor = UIColor.blackColor.CGColor;
//    view2.layer.borderWidth = 2;
//    [self.view addSubview:view2];
//    
//    UIView *view3 = UIView.new;
//    view3.backgroundColor = UIColor.blueColor;
//    view3.layer.borderColor = UIColor.blackColor.CGColor;
//    view3.layer.borderWidth = 2;
//    [self.view addSubview:view3];
//    
//    __weak UIView *superview = self.view;
//    int padding = 10;
//    __weak UIView * _view1 = view1;
//    __weak UIView * _view2 = view2;
//    __weak UIView * _view3 = view3;
//    
//    //if you want to use Masonry without the mas_ prefix
//    //define MAS_SHORTHAND before importing Masonry.h see Masonry iOS Examples-Prefix.pch
//    [view1 makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(superview.top).offset(padding);
//        make.left.equalTo(superview.left).offset(padding);
//        make.bottom.equalTo(_view3.top).offset(-padding);
//        make.right.equalTo(_view2.left).offset(-padding);
//        make.width.equalTo(100);//view2.width
//        
//        make.height.equalTo(_view2.height);
//        make.height.equalTo(_view3.height);
//    }];
//    
//    //with is semantic and option
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superview.mas_top).with.offset(padding); //with with
//        make.left.equalTo(_view1.mas_right).offset(padding); //without with
//        make.bottom.equalTo(_view3.mas_top).offset(-padding);
//        make.right.equalTo(superview.mas_right).offset(-10);
//        //        make.width.equalTo(view1.mas_width);
//        //        make.width.equalTo(view1.mas_right).offset(10);
//        
//        make.height.equalTo(@[_view1, _view3]); //can pass array of views
//    }];
//    
//    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_view1.mas_bottom).offset(padding);
//        make.left.equalTo(superview.mas_left).offset(padding);
//        make.bottom.equalTo(superview.mas_bottom).offset(-padding);
//        make.right.equalTo(superview.mas_right).offset(-padding);
//        make.height.equalTo(@[_view1.mas_height, _view2.mas_height]); //can pass array of attributes
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"text1";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
