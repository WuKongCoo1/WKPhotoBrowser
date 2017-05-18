//
//  WKTapDetectingView.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/17.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "WKTapDetectingView.h"

@implementation WKTapDetectingView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1) {
        [self performSelector:@selector(handleSingleTap:) withObject:touch afterDelay:0.3];
    }else if(touch.tapCount == 2)
    {
        [self performSelector:@selector(handleDoubleTap:) withObject:touch afterDelay:0.3];
    }else if (touch.tapCount == 3){
        [self handleTripleTap:touch];
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
