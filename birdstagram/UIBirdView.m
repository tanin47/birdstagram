//
//  UIBirdView.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBirdView.h"

@implementation UIBirdView

@synthesize actionSheetBird;
@synthesize selectedBird;
@synthesize birds;


- (void) setSelectedBird:(BirdOverlay *) newOne
{
    if (selectedBird != nil) {
        selectedBird.selected = NO;
    }
    
    [selectedBird release];
    selectedBird = [newOne retain];
    
    newOne.selected = YES;
}


- (void) addBird: (BirdOverlay *) bird
{
    if (self.birds == nil) {
        self.birds = [NSMutableArray arrayWithCapacity:5];
    }
    
    [self.birds addObject:bird];
    [self addSubview:bird];
    
    self.selectedBird = bird;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBird:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [bird addGestureRecognizer:tap];
    [tap release];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showBirdOption:)];
    longPress.numberOfTouchesRequired = 1;
    [bird addGestureRecognizer:longPress];
    [longPress release];
}


- (IBAction) tapBird: (UIGestureRecognizer *) recognizer
{
    BirdOverlay *bird = (BirdOverlay *)recognizer.view;
    
    if (bird == self.selectedBird) {
        self.selectedBird = nil;
    } else {
        self.selectedBird = bird;
    }
}



- (IBAction) showBirdOption: (UIGestureRecognizer *) recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
    
    self.actionSheetBird = (BirdOverlay *)recognizer.view;

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
															 delegate:self
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"Remove" 
													otherButtonTitles:nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
	//DLog(@"");
	if (index == sender.destructiveButtonIndex) {
        [self removeBird:self.actionSheetBird];
	}
    
    self.actionSheetBird = nil;
}


- (void) removeBird:(BirdOverlay *)bird
{
    [self.birds removeObject:bird];
    [bird removeFromSuperview];
}

- (void) reset
{
    DLog(@"Reset");
    for (BirdOverlay *b in self.birds) {
        [b removeFromSuperview];
    }
    
    [self.birds removeAllObjects];
}


- (void) rotate: (CGFloat) angle
{
    if (self.selectedBird == nil) return;

    self.selectedBird.transform = CGAffineTransformRotate(self.selectedBird.transform, angle);
}

- (void) pinch: (CGFloat) scale
{
    if (self.selectedBird == nil) return;
    
    self.selectedBird.transform = CGAffineTransformScale(self.selectedBird.transform, scale, scale);
}

- (void) translation: (CGPoint) diff
{
    if (self.selectedBird == nil) return;
    
    self.selectedBird.center = CGPointMake(self.selectedBird.center.x + diff.x, self.selectedBird.center.y + diff.y);
}

@end
