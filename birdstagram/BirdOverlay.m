//
//  BirdOverlay.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdOverlay.h"

@implementation BirdOverlay


@synthesize birdImageView;
@synthesize originalBird;
@synthesize originalBirdSize;

- (void) setSelected:(BOOL)newOne {
    [super setSelected:newOne];
    
    birdImageView.highlighted = newOne;
}



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

}


- (void) setOriginalBird:(UIImage *)newBird {
    
    [originalBird release];
    originalBird = [newBird retain];
    
    
    int maxWidth = 150;
    int maxHeight = 150;
    
    int newWidth = originalBird.size.width;
    int newHeight = originalBird.size.height;
    
    if (newWidth > maxWidth || newHeight > maxHeight) {
        
        newHeight = maxHeight;
        newWidth = originalBird.size.width * newHeight / originalBird.size.height;
        
        if (newWidth > maxWidth) {
            newWidth = maxWidth;
            newHeight = originalBird.size.height * newWidth / originalBird.size.width;
        }
        
    }
    
    self.originalBirdSize = CGSizeMake(newWidth, newHeight);
    
    if (self.birdImageView == nil) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:self.frame];
        self.birdImageView = v;
        [self addSubview:v];
        [v release];
    }
    
    self.birdImageView.image = originalBird;
}


- (void) setHighlightedBird: (UIImage *) image {
    self.birdImageView.highlightedImage = image;
}

@end
