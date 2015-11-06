//
//  IGTabSliderView.m
//
//  Created by ideago on 15/9/29.
//  Copyright (c) 2015年 ideago. All rights reserved.
//

#import "IGTabSliderView.h"

@interface IGTabSliderView()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *topTitlesView;

@property (nonatomic,weak) UIScrollView *contentView;

// 下划线指示器
@property (nonatomic,weak) UIView *indicatorView;

@property (nonatomic,strong) NSMutableArray *titleLabels;

@property (nonatomic,assign) NSUInteger currentPageIndex;

@end

@implementation IGTabSliderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setDefaultConfig];
    }
    
    return self;
}


/**
 *  @author ideago, 15-10-09 21:10:18
 *
 *  设置默认参数
 */
- (void)setDefaultConfig
{
    _currentPageIndex = 0;
    // 默认title为不等宽的
    _style = IGTabSliderViewStyleNotEqualWidth;
    _topBackgroundColor = [UIColor whiteColor];
    
    _topTitleNormalColor = [UIColor blackColor];
    _topTitleHighlightedColor = [UIColor redColor];
    
    _titleLeftPadding = 15.0;
    _titleTopPadding = 5.0;
    _titleHorizontalInterval = 15.0;
    _topTitleViewHeight = 50.0;
    _indicatorViewEnabled = YES;
}


#pragma mark - 数据设置

- (void)setTitles:(NSArray *)titles
{
    self.topTitlesView.frame = CGRectMake(0, 0, self.frame.size.width, _topTitleViewHeight);
    self.topTitlesView.contentSize = CGSizeMake(self.frame.size.width, _topTitleViewHeight);

    _titles = titles;
    
    
    CGFloat titleW = 0;
    
    CGFloat titleH = _topTitleViewHeight -2*_titleTopPadding;
    
    _titleLabels = [NSMutableArray array];
    
    for (int i = 0; i <titles.count; i++) {
        
        
        UILabel *label = [[UILabel alloc]init];
        label.userInteractionEnabled = YES;
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:16.0];
        [label setTextColor:_topTitleNormalColor];
        
        
        // 根据不同的风格设置frame
        if (_style == IGTabSliderViewStyleNotEqualWidth) {
            
            titleW = [titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, titleH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.width;
            
            
            if (i == 0) {
                label.frame = CGRectMake(_titleLeftPadding, _titleTopPadding, titleW, titleH);
            }else{
                label.frame = CGRectMake(CGRectGetMaxX([_titleLabels[i-1] frame])+_titleHorizontalInterval,_titleTopPadding,titleW,titleH);
            }
            
        }else{
            titleW = (self.frame.size.width - 2*_titleLeftPadding -(titles.count-1)*_titleHorizontalInterval) / titles.count;
            // 等宽页面内容居中，否则下面的下划线可能会错位
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(_titleLeftPadding+i*(_titleHorizontalInterval+titleW), _titleTopPadding, titleW, titleH);
        }
        
        label.tag = i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTitleLabel:)]];
        [_titleLabels addObject:label];
        [_topTitlesView addSubview:label];
        
    }
    
    // 调整titlesView的contentSize
    _topTitlesView.contentSize = CGSizeMake(CGRectGetMaxX([[_titleLabels lastObject] frame])+_titleHorizontalInterval, _topTitlesView.contentSize.height);
    
    [_titleLabels[0] setTextColor:_topTitleHighlightedColor];
    
    self.indicatorView.hidden = !_indicatorViewEnabled;
    _indicatorView.backgroundColor = _topTitleHighlightedColor;
    _indicatorView.frame = CGRectMake([_titleLabels[0] frame].origin.x-5, CGRectGetMaxY([_titleLabels[0] frame])-2, [_titleLabels[0] frame].size.width+10, 2);
    
}

- (void)setSubContentViews:(NSArray *)subContentViews
{
   self.contentView.frame = CGRectMake(0, _topTitleViewHeight, self.frame.size.width, self.frame.size.height-_topTitleViewHeight);
    _subContentViews = subContentViews;
    
    for (int i = 0; i <subContentViews.count; i++) {
        [subContentViews[i] setFrame:CGRectMake(self.contentView.frame.size.width*i, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:subContentViews[i]];
    }
    
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width*subContentViews.count, self.contentView.frame.size.height);
    
    self.contentView.pagingEnabled = YES;
}



#pragma mark - 事件处理

- (void)tapTitleLabel:(UITapGestureRecognizer *)tap
{
    
    UILabel *tappedLabel = (UILabel *)tap.view;
    _currentPageIndex = tappedLabel.tag;
    [self highlightTappedLabel:tappedLabel];

}

#pragma mark - 懒加载创建子视图

- (UIScrollView *)topTitlesView
{
    if (_topTitlesView == nil) {
        UIScrollView *topTitlesView = [[UIScrollView alloc]init];
        topTitlesView.bounces = NO;
        topTitlesView.showsHorizontalScrollIndicator = NO;
        [self addSubview:topTitlesView];
        _topTitlesView = topTitlesView;
    }
    return _topTitlesView;
}


- (UIScrollView *)contentView
{
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc]init];
        contentView.bounces = NO;
        contentView.delegate = self;
        contentView.backgroundColor = [UIColor orangeColor];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIView *)indicatorView
{
    if (_indicatorView == nil) {
        
        UIView *indicatorView = [[UIView alloc]init];
        [self.topTitlesView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    
    return _indicatorView;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    _currentPageIndex = index;
    
    [self highlightTappedLabel:_titleLabels[index]];
    
}

#pragma mark  - 辅助方法


/**
 *  @author ideago, 15-10-09 16:10:41
 *
 *  让被点击的label处于高亮状态，同时移动下划线指示器
 *
 *  @param tappedLabel 被点击的label
 */

- (void)highlightTappedLabel:(UILabel *)tappedLabel
{
    
    for (UILabel *label in _titleLabels) {
        label.textColor = _topTitleNormalColor;
    }
    tappedLabel.textColor = _topTitleHighlightedColor;
    
    [UIView animateWithDuration:0.3 animations:^{
        _indicatorView.frame = CGRectMake(tappedLabel.frame.origin.x-5, CGRectGetMaxY(tappedLabel.frame)-2, tappedLabel.frame.size.width+10, 2);
    }];
    
    
    [_contentView scrollRectToVisible:CGRectMake(_contentView.frame.size.width*tappedLabel.tag, 0, _contentView.frame.size.width, _contentView.frame.size.height) animated:NO];
 
    // 当titleLabel的后半部分被右边遮挡时
    if (CGRectGetMaxX(tappedLabel.frame) > self.frame.size.width+_topTitlesView.contentOffset.x) {
        _topTitlesView.contentOffset = CGPointMake(CGRectGetMaxX(tappedLabel.frame)-self.frame.size.width+15, 0);
        return;
    }
    
    // 当title的前半部分被左边遮挡时
    if (_topTitlesView.contentOffset.x > tappedLabel.frame.origin.x) {
        _topTitlesView.contentOffset = CGPointMake(CGRectGetMaxX(tappedLabel.frame) -tappedLabel.frame.size.width-15,0);
    }

}


#pragma mark - 设置属性

- (void)setStyle:(IGTabSliderViewStyle)style
{
    _style = style;
    if (_style == IGTabSliderViewStyleEqualWidth) {
        self.topTitlesView.scrollEnabled = NO;
    }else{
        self.topTitlesView.scrollEnabled = YES;
    }
}

- (void)setTopBackgroundColor:(UIColor *)topBackgroundColor
{
    _topBackgroundColor = topBackgroundColor;
    self.topTitlesView.backgroundColor = topBackgroundColor;
}

- (void)setTopTitleNormalColor:(UIColor *)topTitleNormalColor
{
    _topTitleNormalColor = topTitleNormalColor;
    
    for (UILabel *label in _titleLabels) {
        label.textColor = _topTitleNormalColor;
    }
    
    // 检测如果不为空再执行，在创建之前设置的话_titleLabels[_currentPageIndex]会出现数组越界问题
    if (_titleLabels) {
        [_titleLabels[_currentPageIndex] setTextColor:_topTitleHighlightedColor];
    }
    
}

- (void)setTopTitleHighlightedColor:(UIColor *)topTitleHighlightedColor
{
    _topTitleHighlightedColor = topTitleHighlightedColor;
    
    // 检测如果不为空再执行，在创建之前设置的话_titleLabels[_currentPageIndex]会出现数组越界问题
    if (_titleLabels) {
        [_titleLabels[_currentPageIndex] setTextColor:_topTitleHighlightedColor];
    }
}



@end
