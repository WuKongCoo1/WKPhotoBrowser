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
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface WKOperation : NSObject<SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;

@end

@implementation WKOperation

- (void)cancel
{
    self.cancelled = YES;
}

@end

@interface WKPhotoBrowserScrollView ()
<
UIScrollViewDelegate,
WKTapDetectingViewDelegate
>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *imageUrlString;//原图url
@property (nonatomic, copy) NSString *thumbImageUrlString;//缩略图url
@property (nonatomic, strong) id<SDWebImageOperation> imageOperation;
@property (nonatomic, strong) id<SDWebImageOperation> thumbImageOperation;

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

#pragma mark - loadImage


- (void)setImageURL:(NSString *)imageUrlString thumb:(NSString *)thumbImageUrlString
{
    [self setProgress:1.f];
    self.imageView.image = nil;
    [self.imageOperation cancel];
    [self.thumbImageOperation cancel];
    NSURL *thumbURL = [NSURL URLWithString:thumbImageUrlString];
    UIImage *thumbImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:thumbImageUrlString];
    if (thumbImage) {
        self.imageView.image = thumbImage;
    }else{//加载缩略图
       self.thumbImageOperation = [self loadImageWithURL:thumbURL
                      progress:^(CGFloat progress) {
            
                      }
                     completed:^(UIImage *image, NSError *error) {
                         self.imageView.image = image;
        }];
    }
    
    NSURL *imageURL = [NSURL URLWithString:imageUrlString];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrlString];
    
    if (image) {
        self.imageView.image = image;
    }else{
        self.imageOperation = [self loadImageWithURL:imageURL
                      progress:^(CGFloat progress) {
                          [self setProgress:progress];
                      }
                     completed:^(UIImage *image, NSError *error) {
                         
        }];
    }
}

- (id <SDWebImageOperation>)loadImageWithURL:(NSURL *)url progress:(void(^)(CGFloat progress))progressBlock completed:(void(^)(UIImage *image, NSError *error))completeBlock
{
    if ([[[url scheme] lowercaseString] isEqualToString:@"assets-library"]) {
        WKOperation *operation = [WKOperation new];
        // Load from asset library async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                @try {
                    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:url
                                   resultBlock:^(ALAsset *asset){
                                       ALAssetRepresentation *rep = [asset defaultRepresentation];
                                       CGImageRef iref = [rep fullScreenImage];
                                       if ([operation isCancelled]) {
                                           return ;
                                       }
                                       if (iref) {
                                           //进行UI修改
                                           dispatch_sync(dispatch_get_main_queue(), ^{
                                               self.imageView.image = [[UIImage alloc] initWithCGImage:iref];
                                           });
                                           
                                       }
                                       
                                   }
                                  failureBlock:^(NSError *error) {
                                      
                                      NSLog(@"从图库获取图片失败: %@",error);
                                      
                                  }];
                } @catch (NSException *e) {
                    NSLog(@"从图库获取图片异常: %@", e);
                }
            }
            
        });
        return operation;
    }
   return [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                options:0
                                               progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                   CGFloat progress = (CGFloat)receivedSize / expectedSize;
                                                   progressBlock(progress);
                                               }
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                  if (error) {
                                                      
                                                      [self.imageView setImage:[UIImage imageNamed:@"ImageError"]];
                                                  }else{
                                                      
                                                      self.imageView.image = image;
                                                      NSLog(@"%@", imageURL);
                                                  }
                                                  [self setProgress:1.f];
                                                  
                                              }];
}

#pragma mark - getter & setter
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = ({
            UIImageView *iv = [UIImageView new];
//            iv.image = [UIImage imageNamed:@"default"];
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
