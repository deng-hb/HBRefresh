//
//  UIScrollView+HBRefresh.h
//  HBRefresh
//
//  Created by denghb on 02/02/2018.
//  Copyright © 2018 denghb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBRefresh : UIControl

+ (instancetype)initWithTarget:(id)target action:(SEL)action;

- (void)beginRefreshing;

- (void)endRefreshing;

@end

@interface HBRefreshHeader : HBRefresh

@end

@interface HBRefreshFooter : HBRefresh

@end

@interface UIScrollView (HBRefresh)

@property (strong, nonatomic) HBRefreshHeader *hb_header;

@property (strong, nonatomic) HBRefreshFooter *hb_footer;

@end

