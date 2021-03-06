//
//  WKPhotoBroswerCell.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKPhotoBroswerCell.h"
#import "WKPhotoBrowserScrollView.h"
#import <Masonry/Masonry.h>
#import "WKTapDetectingView.h"

@interface WKPhotoBroswerCell ()
<
UIScrollViewDelegate,
WKTapDetectingViewDelegate
>

@property (nonatomic, strong) IBOutlet WKPhotoBrowserScrollView *scrollView;
@property (nonatomic, strong)  WKTapDetectingView *tapView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;


@end

@implementation WKPhotoBroswerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonSetup];
}

- (void)commonSetup
{
//    [self tapView];
    [self scrollView];
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self.contentView addGestureRecognizer:tapGes];
}

- (void)prepareForReuse
{
    [self.scrollView setZoomScale:1.f];
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
    self.scrollView.scrollEnabled = NO;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%@", NSStringFromCGSize(scrollView.contentSize));
    self.scrollView.scrollEnabled = YES;

}

- (void)handleTap:(UITapGestureRecognizer *)ges
{
}

- (CGRect)zoomRectWithTouchPoint:(CGPoint)point zoomScale:(CGFloat)zoomScale
{
    CGFloat newZoomScale = zoomScale;
    CGFloat xsize = _scrollView.contentSize.width / newZoomScale;
    CGFloat ysize = _scrollView.contentSize.height / newZoomScale;
    CGRect zoomRect = CGRectMake(point.x - xsize/2, point.y - ysize/2, xsize, ysize);
    return zoomRect;
}

#pragma mark - getter & setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = ({
            
            WKPhotoBrowserScrollView *scrollView = [WKPhotoBrowserScrollView new];

            scrollView.maximumZoomScale = 3;
            scrollView.minimumZoomScale = 1;
            
            [self.contentView addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.height.equalTo(self.contentView);
                make.width.equalTo(self.contentView).mas_offset(-20);
                
            }];
            
            scrollView;
        });
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = ({
            UIImageView *iv = [UIImageView new];
            iv.image = [UIImage imageNamed:@"default"];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv;
        });
    }
    return _imageView;
}

- (WKTapDetectingView *)tapView
{
    if (_tapView == nil) {
        _tapView = ({
            WKTapDetectingView *v = [WKTapDetectingView new];
            v.userInteractionEnabled = YES;
            [self.contentView addSubview:v];
            
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            v.tapDelegate = self;
            v;
        });
    }
    return _tapView;
}

#pragma mark -  加载图片
- (void)setImageURL:(NSString *)imageUrlString thumb:(NSString *)thumbImageUrlString
{
    [self.scrollView setImageURL:imageUrlString thumb:thumbImageUrlString];
}


@end
