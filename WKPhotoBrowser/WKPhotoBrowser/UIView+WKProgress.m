//
//  UIView+WKProgress.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/18.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "UIView+WKProgress.h"
#import "WKProgressView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static void * WKProgresssKey = &WKProgresssKey;

@interface UIView ()

@property (strong, nonatomic) WKProgressView *progressView;

@end

@implementation UIView (WKProgress)

- (void)setProgress:(CGFloat)progress
{
    self.progressView.hidden = progress >= 1;
    if (self.progressView.hidden) {
        return;
    }
    self.progressView.progress = progress;
    [self bringSubviewToFront:self.progressView];
}

#pragma mark - getter & setter

- (WKProgressView *)progressView
{
    WKProgressView *pv = objc_getAssociatedObject(self, WKProgresssKey);
    
    if(pv == nil){
        pv = [[WKProgressView alloc] init];
        pv.trackColor = pv.progressColor = [UIColor whiteColor];
        [self addSubview:pv];
        
        [pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
            make.center.equalTo(self);
        }];
        
        self.progressView = pv;
    }
    
    return pv;
}

- (void)setProgressView:(WKProgressView *)progressView
{
    objc_setAssociatedObject(self, WKProgresssKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
