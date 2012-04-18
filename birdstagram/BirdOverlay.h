//
//  BirdOverlay.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdOverlay : UIControl

@property (nonatomic, retain) UIImageView *birdImageView;
@property (nonatomic, retain) UIImage *originalBird;
@property CGSize originalBirdSize;

- (void) setHighlightedBird: (UIImage *) image;
- (void) setup;

@end
