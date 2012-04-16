//
//  DraggableView.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIPreview.h"

@implementation UIPreview


@synthesize anchor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
	//DLog(@"");
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	
	return self;
}


- (void) setup
{
    UIRotationGestureRecognizer *twoFingersRotate = 
    [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    UIPinchGestureRecognizer *twoFingersPinch = 
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    twoFingersRotate.delegate = self;
    twoFingersPinch.delegate = self;


    UIPanGestureRecognizer *oneFingerPan = 
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerPan:)];
    [oneFingerPan setMinimumNumberOfTouches:1];
    [oneFingerPan setMaximumNumberOfTouches:1];
    
    
    [self addGestureRecognizer:twoFingersPinch];
    [self addGestureRecognizer:twoFingersRotate];
    [self addGestureRecognizer:oneFingerPan];
    
    
    [twoFingersPinch release];
    [twoFingersRotate release];
    [oneFingerPan release];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer
{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
   
            break;
            
        case UIGestureRecognizerStateEnded:
            
            [self multiplexRecognizer:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            [self multiplexRecognizer:recognizer];
            break;
            
        }
            
        default:
            break;
    }
}


- (void) multiplexRecognizer: (UIGestureRecognizer *) recognizer
{
    if ([recognizer respondsToSelector:@selector(rotation)]) {
        
        UIRotationGestureRecognizer *rotateRecognizer = (UIRotationGestureRecognizer *) recognizer;
        
        [self rotate:rotateRecognizer.rotation];
        rotateRecognizer.rotation = 0;
        
    } else if ([recognizer respondsToSelector:@selector(scale)]) {
        
        UIPinchGestureRecognizer *pinchGesture = (UIPinchGestureRecognizer *) recognizer;
        
        [self pinch:pinchGesture.scale];
        pinchGesture.scale = 1;
        
    }
}


- (void) rotate: (CGFloat) angle
{
    
}

- (void) pinch: (CGFloat) scale
{
    
}

- (void) translation: (CGPoint) diff
{
    
}



- (void) oneFingerPan: (UIPanGestureRecognizer *)recognizer
{
    
    CGPoint diff = [recognizer translationInView:self];
    //NSLog(@"Translation: %f %f", translation.x, translation.y);
    
    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    [self translation:diff];
}


@end
