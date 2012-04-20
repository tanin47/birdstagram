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
@synthesize originalBirdPath;

- (void) setSelected:(BOOL)newOne {
    [super setSelected:newOne];
    
    if (self.selected == YES) {
        
        [UIView animateWithDuration:0.05 
                              delay:0.0 
                            options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) 
                         animations:^{
                             [UIView setAnimationRepeatCount:3.0];
                             self.birdImageView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             self.birdImageView.alpha = 1.0;
                         }];


    }
    
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


- (void) setOriginalBirdPath: (NSString *) path {
    
    [originalBirdPath release];
    originalBirdPath = [path retain];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    CGFloat targetWidth = image.size.width;
    CGFloat targetHeight = image.size.height;
    
    if (targetWidth > 150 || targetHeight > 150)
    {
        if (image.size.width < image.size.height)
        {
            targetHeight = 150;
            targetWidth = (targetHeight * image.size.width / image.size.height);
        }
        else
        {
            targetWidth = 150;
            targetHeight = (targetWidth * image.size.height / image.size.width);
        }
    }
    
    self.frame = CGRectMake(0, 0, targetWidth, targetHeight);
    
    if (self.birdImageView == nil) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:self.frame];
        self.birdImageView = v;
        [self addSubview:v];
        [v release];
    }
    
    self.birdImageView.frame = self.frame;
    
    self.birdImageView.image = image;
    [image release];
}


@end
