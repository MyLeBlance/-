//
//  HHHViewController.m
//  网易新闻首页联动demo
//
//  Created by 宋庆亮 on 16/8/28.
//  Copyright © 2016年 liang. All rights reserved.
//

#import "HHHViewController.h"

@interface HHHViewController ()

@end

@implementation HHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"hello world";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backToWY)];
    // Do any additional setup after loading the view.
}

- (void)backToWY {
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
