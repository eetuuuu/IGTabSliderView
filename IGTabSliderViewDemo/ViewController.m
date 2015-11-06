//
//  ViewController.m
//  IGTabSliderViewDemo
//
//  Created by ideago on 15/10/12.
//  Copyright (c) 2015年 ideago. All rights reserved.
//

#import "ViewController.h"
#import "IGTabSliderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    IGTabSliderView *sliderView = [[IGTabSliderView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    
    sliderView.style = IGTabSliderViewStyleEqualWidth;
    sliderView.topTitleViewHeight = 60.0;
    sliderView.titleLeftPadding = 40.0;
    sliderView.titleHorizontalInterval = 80.0;
    sliderView.topTitleHighlightedColor = [UIColor magentaColor];
    sliderView.topTitleNormalColor = [UIColor grayColor];
    sliderView.titles = @[@"等宽页面1",@"等宽页面2"];
    
    NSMutableArray *contentViews = [NSMutableArray array];
    
    for (int i = 0; i <2; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0  blue:arc4random()%255/255.0  alpha:1.0];
        
        [contentViews addObject:view];
    }
    
    sliderView.subContentViews = contentViews;
    
    [self.view addSubview:sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
