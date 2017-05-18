//
//  WKProgressView.h
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/18.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKProgressView : UIView

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;

@property (nonatomic, assign) CGFloat progress;
@end
