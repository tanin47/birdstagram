//
//  DraggableView.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPreview : UIView<UIGestureRecognizerDelegate> {

}

@property CGPoint anchor;


- (void) multiplexRecognizer: (UIGestureRecognizer *) recognizer;

- (void) rotate: (CGFloat) angle;
- (void) pinch: (CGFloat) scale;
- (void) translation: (CGPoint) diff;


- (void) setup;
- (void) oneFingerPan: (UIPanGestureRecognizer *)recognizer;

@end
