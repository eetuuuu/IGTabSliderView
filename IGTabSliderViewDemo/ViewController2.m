//
//  ViewController2.m
//  
//
//  Created by ideago on 15/10/12.
//
//

#import "ViewController2.h"
#import "IGTabSliderView.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IGTabSliderView *sliderView = [[IGTabSliderView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30)];
    
        sliderView.topTitleHighlightedColor = [UIColor greenColor];
    sliderView.topTitleNormalColor = [UIColor lightGrayColor];
    
    sliderView.titles = @[@"不等宽页面1",@"非空想家",@"水果",@"ideago",@"小叮当",@"英雄联盟",@"小提莫",@"ONE",@"蚁人",@"nima",@"百撕不得骑姐"];
    
    NSMutableArray *contentViews = [NSMutableArray array];
    
    for (int i = 0; i <11; i++) {
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
