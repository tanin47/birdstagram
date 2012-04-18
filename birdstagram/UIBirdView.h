//
//  UIBirdView.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BirdOverlay.h"

@interface UIBirdView : UIPreview<UIActionSheetDelegate>

@property (nonatomic, retain) BirdOverlay *selectedBird;
@property (nonatomic, retain) BirdOverlay *actionSheetBird;
@property (nonatomic, retain) NSMutableArray *birds;

- (IBAction) showBirdOption: (UIGestureRecognizer *) recognizer;
- (IBAction) tapBird: (UIGestureRecognizer *) recognizer;

- (void) addBird: (BirdOverlay *) bird;
- (void) removeBird: (BirdOverlay *) bird;
- (void) reset;

@end
