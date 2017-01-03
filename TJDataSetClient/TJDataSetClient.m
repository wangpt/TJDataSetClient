//
//  TJDataSetClient.m
//  TJDataSetClient
//
//  Created by 王朋涛 on 16/8/31.
//  Copyright © 2016年 王朋涛. All rights reserved.
//

#import "TJDataSetClient.h"
@interface TJDataSetClient ()
@property (nonatomic, strong) UIScrollView *emptyView;
@end
@implementation TJDataSetClient
- (instancetype)initWithSuperScrollView:(UIScrollView*)sv
{
    self = [super init];
    if (self) {
        sv.emptyDataSetDelegate = self;
        sv.emptyDataSetSource = self;
        self.emptyView=sv;
    }
    return self;
}
- (void)setState:(NetWorkingState)state{
    _state = state;
    if (state==netWorkingErrorState) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.emptyView reloadEmptyDataSet];
        });
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emptyView reloadEmptyDataSet];
            
        });
    }
    
}


#pragma mark - DZNEmptyDataSetSource
/**
 *  空白页图片
 *
 *  @param scrollView superview
 *
 *  @return 空白页图片
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if ( _state == noDataState || _state == failureLoadState) {
        return _emptyDefaultImage?_emptyDefaultImage:[UIImage imageNamed:@"TJDataSetClient.bundle/page_icon_empty"];
    } else if ( _state == netWorkingErrorState) {
        return [UIImage imageNamed:@"TJDataSetClient.bundle/page_icon_network"];
    } else if (_state == emptyViewState){
        return [UIImage new];
    }else if (_state ==loadingState){
        return [UIImage imageNamed:@"TJDataSetClient.bundle/page_icon_loading"];
    }
    return nil;
}
//图片的动画效果

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
/**
 *  自定义视图
 *
 *  @param scrollView superview
 *
 *  @return 定义
 */
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_state == emptyViewState) {
        return [UIView new];
    }
    return nil;
}

/**
 *  详情样式
 *
 *  @param scrollView superview
 *
 *  @return 样式
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if (_state == loadingState) {
        text = @"";
    } else if (_state == noDataState) {
        text = _respondString?_respondString:@"没有相关数据";
    } else if (_state == failureLoadState) {
        text = _respondString?_respondString:@"加载失败";
    } else if (_state == netWorkingErrorState) {
        text = @"网络未连接";
    } else if (_state == emptyViewState) {
        text = @"";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName : paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
/**
 *  标题样式
 *
 *  @param scrollView superview
 *
 *  @return 样式
 */
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (_state == failureLoadState || _state == netWorkingErrorState) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                     };
        
        return [[NSAttributedString alloc] initWithString:@"点击重新加载" attributes:attributes];
    }
    return nil;
}
/**
 *  背景颜色
 *
 *  @param scrollView superview
 *
 *  @return 颜色
 */

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:0];
}
//偏移水平的距离
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{    
    CGFloat offset = _verticalOff?_verticalOff:0;
    return -offset;
}
//组件间的空隙xxa
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20;
}

#pragma mark - DZNEmptyDataSetDelegate
//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
//图片是否要动画效果，默认NO
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    if (_state == loadingState) {
        return YES;
    }
    return NO;
}
//空白页点击事件
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    if (self.reloading) {
        self.reloading();
    }
}
//空白页按钮点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    if (self.reloading) {
        self.reloading();
    }
}

@end
