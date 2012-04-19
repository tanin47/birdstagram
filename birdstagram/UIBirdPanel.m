//
//  UIBirdPanel.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBirdPanel.h"
#import "BirdCell.h"


@implementation UIBirdPanel



@synthesize birds;
@synthesize birdDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBirds];
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
	//DLog(@"");
	if (self = [super initWithCoder:aDecoder]) {
		[self setupBirds];
	}
	
	return self;
}


- (void) setupBirds
{
    
    NSLog(@"%@",[NSThread callStackSymbols]);

    self.horizontalDelegate = self;
    
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * birdsPath = [resourcePath stringByAppendingPathComponent:@"Birds"];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:birdsPath error:&error];
    
    self.birds = [NSMutableArray arrayWithCapacity:([directoryContents count]/2)];
    
    DLog(@"%@", directoryContents);
    
    for (NSString *fileName in directoryContents) {
    
        Bird *bird = [[Bird alloc] init];
        bird.originalImagePath = [NSString stringWithFormat:@"Birds/%@",fileName];
                              
        [self.birds addObject:bird];
        [bird release];
        
        DLog(@"%@", fileName);
    }
}

- (void) dealloc
{
    self.birdDelegate = nil;
    self.birds = nil;
    
    [super dealloc];
}


- (void) tableView: (UIHorizontalTableView *) tableView didSelectColumnAt: (int) columnIndex
{
    Bird *bird = [self.birds objectAtIndex:columnIndex];
    [self.birdDelegate birdPanel:self didSelectBird:bird];
}
     

- (CGFloat) tableViewWidthForColumn: (UIHorizontalTableView *) tableView
{
    return 70;
}
     

- (NSInteger) numberOfColumns: (UIHorizontalTableView *) tableView
{
    return [self.birds count];;
}
     

- (UIView *) tableView: (UIHorizontalTableView *) tableView cellForColumnAt: (int) columnIndex
{
    BirdCell *cell = (BirdCell *)[self dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[[BirdCell alloc] init] autorelease];
    }
    
    Bird * bird = (Bird *)[self.birds objectAtIndex:columnIndex];
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * birdPath = [resourcePath stringByAppendingPathComponent:bird.originalImagePath];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:birdPath];
    
    cell.birdImage.image = image;
    
    [image release];
    
    return cell;
}

@end
