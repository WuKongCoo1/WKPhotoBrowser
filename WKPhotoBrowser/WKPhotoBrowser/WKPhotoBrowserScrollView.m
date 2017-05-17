//
//  WKPhotoBrowserScrollView.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKPhotoBrowserScrollView.h"
#import "WKTapDetectingView.h"
#import <Masonry/Masonry.h>

@interface WKPhotoBrowserScrollView ()
<
WKTapDetectingViewDelegate
>
@property (nonatomic, strong) WKTapDetectingView *tapView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WKPhotoBrowserScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


@end
