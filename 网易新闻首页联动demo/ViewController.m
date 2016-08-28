//
//  ViewController.m
//  网易新闻首页联动demo
//
//  Created by 宋庆亮 on 16/8/25.
//  Copyright © 2016年 liang. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "JCLabel.h"
#import "ContentTableViewController.h"
@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网易新闻";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addScrollView];
    [self addContentView];
    [self addTitleView];
    
    // 默认显示
//    [self.contentScrollView addSubview:self.childViewControllers[0].view];
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
}

- (void)addScrollView {
    self.titleScrollView = [[UIScrollView alloc] init];
    self.titleScrollView.frame = CGRectMake(0, 64, kWidth, 40);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.titleScrollView];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, 104, kWidth, kHeight - 104);
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
}

- (void)addContentView {
    
    ContentTableViewController *first = [[ContentTableViewController alloc] init];
    first.title = @"政治";
    [self addChildViewController:first];
    
    ContentTableViewController *second = [[ContentTableViewController alloc] init];
    second.title = @"经济";
    [self addChildViewController:second];
    
    ContentTableViewController *third = [[ContentTableViewController alloc] init];
    third.title = @"军事";
    [self addChildViewController:third];
    
    ContentTableViewController *fourth = [[ContentTableViewController alloc] init];
    fourth.title = @"文化";
    [self addChildViewController:fourth];
    
    ContentTableViewController *fifth = [[ContentTableViewController alloc] init];
    fifth.title = @"娱乐";
    [self addChildViewController:fifth];
    
    ContentTableViewController *sixth = [[ContentTableViewController alloc] init];
    sixth.title = @"游戏";
    [self addChildViewController:sixth];
    
    ContentTableViewController *seventh = [[ContentTableViewController alloc] init];
    seventh.title = @"影视";
    [self addChildViewController:seventh];
}

- (void)addTitleView {
    
    for (NSInteger i = 0; i < 7; i++) {
        
        CGFloat titleX = i * 100;
        JCLabel *titleLabel = [[JCLabel alloc] initWithFrame:CGRectMake(titleX, 0, 100, 40)];
        titleLabel.text = [NSString stringWithFormat:@"%@", [self.childViewControllers[i] title]];
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
        titleLabel.tag = i;
        [self.titleScrollView addSubview:titleLabel];
        self.titleScrollView.contentSize = CGSizeMake(700, 0);
        self.contentScrollView.contentSize = CGSizeMake(kWidth * 7, 0);

        // 页面显示之初第一个label的颜色和字体（封装的好处）
        if (i == 0) {
            titleLabel.scale = 1;
        }
    }

}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    
//    NSInteger index = [self.titleScrollView.subviews indexOfObject:tap.view];//同样可以算出索引
    
    NSInteger index = sender.view.tag;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat contentX = scrollView.contentOffset.x;
    CGFloat contentW = scrollView.frame.size.width;
    CGFloat contentH = scrollView.frame.size.height;
    // 当前位置需要显示的控制器的索引
    NSInteger index = contentX / contentW;
    NSLog(@"======%zd", index);
    JCLabel *clickLabel = self.titleScrollView.subviews[index];
    CGPoint offset = self.titleScrollView.contentOffset;
    offset.x = clickLabel.center.x - 0.5 * contentW; // 偏移量的x值等于当前label的中心点x值减去半个屏幕的宽度
    // 左边超出处理
    if (offset.x < 0) offset.x = 0;
    // 右边超出处理
    CGFloat maxOffset = self.titleScrollView.contentSize.width - contentW;
    if (offset.x > maxOffset) offset.x = maxOffset;
    [self.titleScrollView setContentOffset:offset animated:YES];
    // 小bug:让其他lebel回到最初的状态（）
    for (JCLabel *otherLabel in self.titleScrollView.subviews) {
        if (otherLabel != clickLabel) {
            otherLabel.scale = 0;
        }
    }
    
    // 取出需要显示的控制器
    UIViewController *showVC = self.childViewControllers[index];
    if ([showVC isViewLoaded]) return;
    showVC.view.frame = CGRectMake(contentX, 0, contentW, contentH);
    [self.contentScrollView addSubview:showVC.view];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
//    NSLog(@"=======%f", scale);
    if (scale < 0 || scale > self.titleScrollView.subviews.count - 1) return; // 防止：第一个和最后一个label再向左边和右边位置移动的时候字体和颜色会发生变化
    // 获得左边需要操作的label
    NSInteger leftIdex = scale;
    JCLabel *leftLabel = self.titleScrollView.subviews[leftIdex];
    
    // 右边比例 && 左边比例
    CGFloat rightScale = scale - leftIdex;
    CGFloat leftScale = 1 - rightScale;
    
    //    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1.0];
    //    leftLabel.font = [UIFont systemFontOfSize:17 + leftScale * 10]; 直接设置字体大小的话字体放大缩小的时候会发抖，应该设置transform
    //    leftLabel.transform = CGAffineTransformMakeScale(1 + leftScale, 1 + leftScale); // 字体有点大，不如直接在封装的label里面设置这些东西
    
//        if (leftIdex == self.titleScrollView.subviews.count - 2) return; // 或者用下面的三目运算符
    // 获得右边需要操作的label
    NSInteger rightIdex = leftIdex + 1;
    JCLabel *rightLabel = (rightIdex == self.titleScrollView.subviews.count) ? nil : self.titleScrollView.subviews[rightIdex];
    // 设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
@end
