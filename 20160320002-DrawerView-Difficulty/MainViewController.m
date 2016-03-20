//
//  MainViewController.m
//  20160320002-DrawerView-Difficulty
//
//  Created by Rainer on 16/3/20.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "MainViewController.h"
#import "TestTableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.创建一个控制器对象，并设置frame
    TestTableViewController *tableViewController = [[TestTableViewController alloc] init];
    tableViewController.view.frame = self.view.bounds;
    
    // 2.为了防止控制器被销毁后报内存无法访问错误，需要引用该控制器对象
    [self addChildViewController:tableViewController];
    
    // 3.将控制器对象的视图添加到主视图上即可展示在控件的主视图上
    [self.mainView addSubview:tableViewController.view];
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
