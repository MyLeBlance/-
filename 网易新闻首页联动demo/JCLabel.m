//
//  JCLabel.m
//  网易新闻首页联动demo
//
//  Created by 宋庆亮 on 16/8/25.
//  Copyright © 2016年 liang. All rights reserved.
//

#define JCRed 0.3
#define JCGreen 0.7
#define JCBlue 0.6

#import "JCLabel.h"

@implementation JCLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.5 alpha:1.0];
//        self.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    
    // R G B
    // 黑色 0 0 0
    // 红色 1 0 0
    // 蓝色 0 0 1
    // 黄色 1 1 0
    
    // 颜色转换的万能公式 = 本身颜色的数值 + （想要转化的颜色的RGB值 - 本身颜色的数值）* scale
//    下面是宏定义的颜色想要转换成红色
//    CGFloat red = JCRed + (1 - JCRed) * scale;
//    CGFloat green = JCGreen + (0 - JCRed) * scale;
//    CGFloat blue = JCBlue + (0 - JCBlue) * scale;
    
    _scale = scale;
    
    CGFloat red = 0.2 + (1 - 0.2) * scale;
    CGFloat green = 0.4 + (0 - 0.4) * scale;
    CGFloat blue = 0.5 + (0 - 0.5) * scale;
    
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    CGFloat transform = 1 + scale * 0.4;
    self.transform = CGAffineTransformMakeScale(transform, transform);
}

@end
