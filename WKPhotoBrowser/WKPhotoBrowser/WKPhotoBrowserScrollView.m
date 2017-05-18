//
//  WKPhotoBrowserScrollView.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKPhotoBrowserScrollView.h"
#import "WKTapDetectingView.h"
#import "UIView+WKProgress.h"
#import <Masonry/Masonry.h>

@interface WKPhotoBrowserScrollView ()
<
UIScrollViewDelegate,
WKTapDetectingViewDelegate
>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WKPhotoBrowserScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    [self imageView];
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    self.delegate = self;
    
    [self addTapGesture];
}

- (void)addTapGesture
{
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    doubleTapGes.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGes];
    
    UITapGestureRecognizer *singleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTapGes.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGes];
    
    
    [singleTapGes requireGestureRecognizerToFail:doubleTapGes];
}

#pragma mark - UIScrollViewDelegate
//缩放时调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//开始缩放的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    scrollView.scrollEnabled = NO;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%@", NSStringFromCGSize(scrollView.contentSize));
    scrollView.scrollEnabled = YES;
}

#pragma mark - 缩放与点击
- (void)handleTap:(UITapGestureRecognizer *)ges
{
    CGPoint point =  [ges locationInView:self];
    
    NSInteger touches = ges.numberOfTapsRequired;
    if (touches == 1) {
        
    }else if(touches == 2){
        [self zoomWithPoint:point];
    }
}

- (void)zoomWithPoint:(CGPoint)point
{
    if (self.minimumZoomScale <= self.zoomScale && self.maximumZoomScale > self.zoomScale * 2)
    {
        // Zoom in to twice the size
        CGRect zoomRect = [self zoomRectWithTouchPoint:point zoomScale:(self.maximumZoomScale + self.minimumZoomScale) / 2];;
        [self zoomToRect:zoomRect animated:YES];
    }
    else{
        if (self.maximumZoomScale > self.zoomScale && self.maximumZoomScale / 2 <= self.zoomScale)
        {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }
        else
        {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
    }
}


- (CGRect)zoomRectWithTouchPoint:(CGPoint)point zoomScale:(CGFloat)zoomScale
{
    CGFloat newZoomScale = zoomScale;
    CGFloat xsize = self.contentSize.width / newZoomScale;
    CGFloat ysize = self.contentSize.height / newZoomScale;
    CGRect zoomRect = CGRectMake(point.x - xsize/2, point.y - ysize/2, xsize, ysize);
    return zoomRect;
}

#pragma mark - getter & setter


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = ({
            UIImageView *iv = [UIImageView new];
            iv.image = [UIImage imageNamed:@"default"];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(self);
                make.width.equalTo(self);
                make.center.equalTo(self);
            }];
            
            iv;
        });
    }
    return _imageView;
}


@end
