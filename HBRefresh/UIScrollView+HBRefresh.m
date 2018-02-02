//
//  UIScrollView+HBRefresh.m
//  HBRefresh
//
//  Created by denghb on 02/02/2018.
//  Copyright © 2018 denghb. All rights reserved.
//

#define HB_IMAGE_REFRESH  @"iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAj9JREFUSA3llstKHEEUhntEIbhz4SXgap7BJIKCDxCQEIIIPoCrLHJZSNwI6kqRQFbBVzBgggRxpXgh4DtkEQJmEiQQRAQv4/cXXc3x0N0zo7MyB/6uOnUuf927kuS+S6WZAdbr9X78xsAoGAS9QHIMfoADsF2pVH5RlkopIURKPA3GQUdppiS5xL4BVsuICwkh04jmQTdoRU5wngMq34EHYJFO7FMmuYSQTWJ7K4c7yBmxIpPUIHyqSqc+VtKR5ZF9x28dfANxrQaoPwbPQRVYiWRq0x4IcmOE6Zp9wmKn8QJ9BazRy6sQ5T7EaX1fgFegy5mDSuyQKn6E2iCe7CXOhyGq4KOOQKoZOAE9BW6hOdt5BGjY2o1WVhqRGecZ6qVk8s0IqWtXWl09XgPNip0ZH/M7NlgCHWor65oq29Cgvoi9luMjMtmC2DXUDWJFu7FpoXM6Z2HrlwXZEcbrKvrHrR/1tpSWsC0JGyWxhH+csw5128US/nTZh53eFtUS7rmMz9IbxDXfTbWEO6Syx6CKruuqJaGTo2ADfAUjPjgjZFvrDH1xDq8JeuTaCtWUYBkHrX8fmPXOGWFq+Eh5apx0Tj+QaAJ438xNNjBFwxKwZ9vOWPC/8bdQC4G64tRLb9NVZ39P6sBD8AToDq4CKyJ7w8zt2kafNNggnZQzyLXbBCX1ecg+e3thwnSkt3li/IVkAbIdTya9kFBGSFt5RJ0TsgXeQybSXCkljBEQ5z0T9Uo7SqGLfhOifzHm/y2vASx6nZD2y69wAAAAAElFTkSuQmCC"

#define HB_IMAGE_OK  @"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAMAAAAM7l6QAAAAaVBMVEVMaXF3d3f///+CgoJ3d3d3d3d3d3ekpKR3d3d3d3d6enp3d3f///93d3f///99fX3///////+zs7N3d3d3d3d3d3f////9/f3////+/v7////W1tZ3d3f///+RkZHc3Nzr6+vPz8+kpKRZlpGxAAAAHHRSTlMAMqz+RIIZCMfW/qtbm+poTM/86yRWPocimCrSqMGl/wAAATJJREFUeF6N0t12gyAQBGAJEEAi/iVN0gyoff+H7ILFUO1F90Y532GYi63+PUxqDWgt2R94M9jG3HZ4jfekYJViojGAPpcqRuj2fZQGoygUsKoMUxZgW/KIZl+lwZjzNeyxqoVe9QatjqwMRGKD9mCM+sGsvfRezwYyvslSCXnUyDKBATvq1z3H1lBH9cRncAKAgDXil57oikKd2QJip8SchMfwFtFLzeEhVjstNXmpsVogHmL/zkdvS60kBuJX6n9JXmql8SJ4crTZS5UId+Juoeur8+GtymD5iF8XYFf3b60sQp9+LjNHk9w9N23A5y6x6qeafLdM9dT/HD4debmKrQaf3CMfOz+HtMhXWjwhNRBmT702d1Qb24TFu0Ipv/d+GkIgCsPkff8oNdX227hLhm+Lfx2VWvyS+gAAAABJRU5ErkJggg=="

#define HB_IMAGE(base64String) [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)]]

#define HB_height     40
#define HB_heightEnd       80
#define HB_contentOffset   @"contentOffset"

#define HB_backgroundColor [UIColor colorWithWhite:0.9 alpha:1]
#define HB_tinColor        [UIColor colorWithWhite:0.7 alpha:1]

#import "UIScrollView+HBRefresh.h"
#import <objc/runtime.h>

@implementation HBRefresh

+ (instancetype)initWithTarget:(id)target action:(SEL)action
{
    HBRefresh *refresh = [[self alloc] init];
    [refresh addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return refresh;
}

- (void)beginRefreshing
{
    NSAssert(1 != 1, @"...");
}

- (void)endRefreshing
{
    NSAssert(1 != 1, @"...");
}

@end

@implementation HBRefreshHeader
{
    UIActivityIndicatorView *_activityIndicatorView;// 菊花
    UIImageView *_innerImageView;// 水滴图片
    UILabel *_tipLabel;// 结束提示
    
    BOOL _refreshing;// 刷新中
    CGFloat _width;// 整个宽度
    CGFloat _height;// 动态高度
    
    UIScrollView *_scrollView;// 当前视图
    NSUInteger _refreshIndex;// 刷新次数
    BOOL _canRefresh;// 能刷新
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [newSuperview addObserver:self forKeyPath:HB_contentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    _refreshing = NO;
    _refreshIndex = 0;
    _canRefresh = YES;
    _width = newSuperview.bounds.size.width;
    
    self.frame = CGRectMake(0, -HB_height, _width, HB_height);
    //    self.clipsToBounds = YES;
    self.backgroundColor = HB_backgroundColor;
    // 初始化
    _innerImageView = [[UIImageView alloc]initWithImage:HB_IMAGE(HB_IMAGE_REFRESH)];
    [_innerImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self addSubview:_innerImageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((_width - 30)/2, 5, 30, 30)];
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView setColor:HB_tinColor];
    [self addSubview:_activityIndicatorView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, HB_height)];
    _tipLabel.font = [UIFont systemFontOfSize:12];
    [_tipLabel setTextColor:HB_tinColor];
    [_tipLabel setHidden:YES];
    NSString *title = @" 刷新成功";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:title];
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = HB_IMAGE(HB_IMAGE_OK);
    attachment.bounds = CGRectMake(0, 0, 12, 12);
    [attr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    [attr addAttribute:NSBaselineOffsetAttributeName value:@(1) range:NSMakeRange(1, title.length)];
    [_tipLabel setAttributedText:attr];
    [_tipLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:_tipLabel];
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:HB_contentOffset];
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:HB_contentOffset]) {
        return;
    }
    
    CGPoint point = [change[@"new"] CGPointValue];
//    NSLog(@"%.f",point.y);
    CGFloat y = point.y;
    if (y >= 0) {
        if (!_refreshing) {
            _canRefresh = YES;
        }
        return;
    }
    _scrollView = object;
    
    CGFloat top = (-y > HB_height) ? y : -HB_height;
    BOOL isPull = _height < -top;// 是否是下拉
    _height = -top;
    self.frame = CGRectMake(0, top, self.frame.size.width, _height);
    
    // 下拉达到刷新点
    if (!_refreshing && _canRefresh && isPull && _height > HB_heightEnd) {
        _canRefresh = NO;
        [self beginRefreshing];
    }
    // 绘制
    [self setNeedsDisplay];
    
    // 如果是刷新中回到最低高度
    if (_refreshing && _height <= HB_height) {
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = HB_height;
        [_scrollView setContentInset:inset];
    }
}

- (void)drawRect:(CGRect)rect
{
    _innerImageView.hidden = NO;
    [_tipLabel setHidden:YES];
    if (!_canRefresh) {
        _innerImageView.hidden = YES;
        return;
    }
    // 上面大圆&下面小圆&一个倒梯形；TODO 在一个位置开始按比例缩放
//    CGFloat coefficient = 0.618;
    // 中间图标
    [_innerImageView setFrame:CGRectMake(0, 10, _width, 20)];
    
    // 大圆
    CGFloat x = (_width - 30)/2;
    CGFloat w = 30;
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, 5, w, w) cornerRadius:w / 2];
    [HB_tinColor setFill];
    [bigCircle fill];
    
    // 小于起始高度
    if (_height < HB_height) {
        return;
    }
    CGFloat y = 20;
    CGFloat h = _height - HB_height;
    // 倒梯形
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x, y)];// 左上
    [path addLineToPoint:CGPointMake(x + w, y)];// 右上
    [path addLineToPoint:CGPointMake(x + w - 5, y + h)];// 右下
    [path addLineToPoint:CGPointMake(x + 5, y + h)];// 左下
    [path closePath];// 关闭路径
    [HB_tinColor setFill];// 设置填充颜色
    [path fill];
    
    // 小圆
    CGFloat sw = w - 10;
    UIBezierPath *smallCircle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x + 5, h + y - sw / 2, sw, sw) cornerRadius:sw / 2];
    [HB_tinColor setFill];
    [smallCircle fill];
    
}

- (void)beginRefreshing
{
    NSLog(@"beginRefreshing(%lu)", ++_refreshIndex);
    _refreshing = YES;
    [_activityIndicatorView startAnimating];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endRefreshing
{
    NSLog(@"endRefreshing(%lu)", _refreshIndex);
    _refreshing = NO;
    [_tipLabel setHidden:NO];
    [_activityIndicatorView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        [_scrollView setContentInset:(UIEdgeInsetsZero)];
    }];
}


@end


@implementation UIScrollView (HBRefresh)

static const char HBRefreshOCHeaderKey = '\0';

- (void)setHb_header:(HBRefreshHeader *)hb_header
{
    if (hb_header != self.hb_header) {
        [self.hb_header removeFromSuperview];
        [self insertSubview:hb_header atIndex:0];
        [self willChangeValueForKey:@"hb_header"];
        objc_setAssociatedObject(self, &HBRefreshOCHeaderKey,hb_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"hb_header"];
    }
}

- (HBRefreshHeader *)hb_header
{
    return objc_getAssociatedObject(self, &HBRefreshOCHeaderKey);
}

@end

