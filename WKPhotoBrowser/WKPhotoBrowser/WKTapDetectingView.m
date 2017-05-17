//
//  WKTapDetectingView.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/17.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKTapDetectingView.h"

@implementation WKTapDetectingView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"====");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        case 3:
            [self handleTripleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(tapDetectingView:singleTapDetected:)])
        [_tapDelegate tapDetectingView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(tapDetectingView:doubleTapDetected:)])
        [_tapDelegate tapDetectingView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(tapDetectingView:tripleTapDetected:)])
        [_tapDelegate tapDetectingView:self tripleTapDetected:touch];
}





@end
