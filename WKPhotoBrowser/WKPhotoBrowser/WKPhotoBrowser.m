//
//  WKPhotoBrowser.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKPhotoBrowser.h"
#import "UIView+WKProgress.h"
#import "WKPhotoBroswerCell.h"

@interface WKPhotoBrowser ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) NSInteger pageIndexBeforeRotation;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (assign, nonatomic) BOOL rotating;
@end

@implementation WKPhotoBrowser

#pragma mark - Class Method
+ (instancetype)photoBrowser
{
    return ({
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"WKPhotoBrowserStoryboard" bundle:nil];
        id vc = [sb instantiateViewControllerWithIdentifier:@"WKPhotoBrowser"];
        vc;
    });
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPageIndex = self.currentIndex;
    
    NSInteger totalCount = -1;
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfphotosInPhotoBrowser:)], @"请实现numberOfphotosInPhotoBrowser:");
    totalCount = [self.dataSource numberOfphotosInPhotoBrowser:self];
    
    NSAssert(totalCount > self.currentPageIndex, @"当前页不能大于总数");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:self.currentPageIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillLayoutSubviews
{
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(numberOfphotosInPhotoBrowser:)]) {
        return [self.dataSource numberOfphotosInPhotoBrowser:self];
    }
    return 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKPhotoBroswerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *imageURL, *thumbImageUrl;
    NSAssert([self.dataSource respondsToSelector:@selector(photoBrowser:imageUrlAtIndex:)], @"请实现photoBrowser:imageUrlAtIndex:方法");
    NSAssert([self.dataSource respondsToSelector:@selector(photoBrowser:thumbImageUrlAtIndex:)], @"请实现photoBrowser:thumbImageUrlAtIndex:方法");
    imageURL = [self.dataSource photoBrowser:self imageUrlAtIndex:indexPath.row];
    thumbImageUrl = [self.dataSource photoBrowser:self thumbImageUrlAtIndex:indexPath.row];
    
    [cell setImageURL:imageURL thumb:thumbImageUrl];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = self.view.bounds.size;
    size.width = collectionView.bounds.size.width;
    if (!self.navigationController.isNavigationBarHidden) {
        size.height -= 64.f;
    }else{
        size.height -= 20.f;
    }
    return size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"=======");

    self.currentPageIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)self.currentPageIndex];
//    NSLog(@"currentIndexPaht = %ld", self.currentPageIndex);
}

#pragma mark - 旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Remember page index before rotation
    _pageIndexBeforeRotation = _currentPageIndex;
//    _rotating = YES;

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Perform layout
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.pageIndexBeforeRotation inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    _rotating = NO;
}

@end
