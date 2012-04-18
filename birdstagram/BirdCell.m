//
//  BirdCell.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdCell.h"

@implementation BirdCell



@synthesize cell;
@synthesize birdImage;


- (id)init
{
    self = [super init];
    if (self) {
		
		[[NSBundle mainBundle] loadNibNamed:@"BirdCell" owner:self options:nil];
		
        [self addSubview:self.cell];
        
        self.frame = self.cell.frame;
        
    }
    return self;
}


@end
