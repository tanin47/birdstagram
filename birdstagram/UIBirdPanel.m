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


@synthesize baseUrl;
@synthesize listUrl;
@synthesize localBirds;
@synthesize remoteBirds;
@synthesize birdDelegate;
@synthesize loadMoreCell;


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
    self.baseUrl = @"http://www.kejuliso.com/stampo";
    self.listUrl = @"http://www.kejuliso.com/stampo/index.php";
    
    self.horizontalDelegate = self;
    
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * birdsPath = [resourcePath stringByAppendingPathComponent:@"Birds"];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:birdsPath error:&error];
    
    self.localBirds = [NSMutableArray arrayWithCapacity:([directoryContents count]/2)];
    self.remoteBirds = [NSMutableArray arrayWithCapacity: 10];
    
    for (NSString *fileName in directoryContents) {
    
        Bird *bird = [[Bird alloc] init];
        bird.originalImagePath = [birdsPath stringByAppendingPathComponent:fileName];
                              
        [self.localBirds addObject:bird];
        [bird release];
    }
}

- (void) dealloc
{
    self.birdDelegate = nil;
    self.localBirds = nil;
    self.remoteBirds = nil;
    self.loadMoreCell = nil;
    
    [super dealloc];
}


- (void) loadMore
{
    [self.loadMoreCell startLoading];
    
    
    ASIHTTPRequest  *request = [ASIHTTPRequest  requestWithURL:[NSURL URLWithString:self.listUrl]];
    [request setRequestMethod:@"GET"];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    
    [request setCompletionBlock:^{
        //DLog(@"");
        SBJsonParser *parser;
        
        @try {
            NSString *content = [request responseString];
            
            DLog(@"%@", content);
            
            parser = [[SBJsonParser alloc] init];
            NSMutableDictionary *response = [parser objectWithString:content];
            
            NSNumber *ok = (NSNumber *)[response objectForKey:@"ok"];
            
            if (![ok boolValue]) {
                self.baseUrl = (NSString *)[response objectForKey:@"base_url"];
                self.listUrl = (NSString *)[response objectForKey:@"list_url"];
                
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [self loadMore];
                });
                
                return;
            }
            
            NSMutableArray *imagePaths = (NSMutableArray *)[response objectForKey:@"birds"];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Stampo"];
            
            [self.remoteBirds removeAllObjects];
            
            for (NSString *path in imagePaths) {
                
                NSString *dest = [documentsDirectory stringByAppendingPathComponent:path];
                [self ensureDir:dest];
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", self.baseUrl, path];
                
                ASIHTTPRequest  *r = [ASIHTTPRequest  requestWithURL:[NSURL URLWithString:imageUrl]];
                [r setRequestMethod:@"GET"];
                [r setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
                [r setDownloadDestinationPath:dest];
                [r startSynchronous];
                
                
                Bird *bird = [[Bird alloc] init];
                bird.originalImagePath = dest;
                
                [self.remoteBirds addObject:bird];
                [bird release];
            }
            
            [self reloadData];
            [self.loadMoreCell ok];
            
        } @catch (id theException) {
            //failCallback();
            NSLog(@"Error: %@", theException);
            [self.loadMoreCell fail];
        } @finally {
            [parser release];
        }
        
    }];
    
    [request setFailedBlock:^{
        //DLog(@"");
        //failCallback();
        [self.loadMoreCell fail];
    }];
    
    [request startAsynchronous];

}


- (void) ensureDir: (NSString *) path
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path 
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:&error];
}

- (void) tableView: (UIHorizontalTableView *) tableView didSelectColumnAt: (int) columnIndex
{
    
    if (columnIndex < ([self.localBirds count] + [self.remoteBirds count])) {
        
        Bird * bird = nil; 
        
        if (columnIndex < [self.localBirds count]) {
            bird = (Bird *)[self.localBirds objectAtIndex:columnIndex];
        } else {
            bird = (Bird *)[self.remoteBirds objectAtIndex:(columnIndex -  [self.localBirds count])];
        }
        
        [self.birdDelegate birdPanel:self didSelectBird:bird];
        
    } else {
        [self loadMore];
    }
    
}
     

- (CGFloat) tableViewWidthForColumn: (UIHorizontalTableView *) tableView
{
    return 70;
}
     

- (NSInteger) numberOfColumns: (UIHorizontalTableView *) tableView
{
    return [self.localBirds count] + [self.remoteBirds count] + 1;
}
     

- (UIView *) tableView: (UIHorizontalTableView *) tableView cellForColumnAt: (int) columnIndex
{
    if (columnIndex < ([self.localBirds count] + [self.remoteBirds count])) {
        
        BirdCell *cell = (BirdCell *)[self dequeueReusableCell];
        if (cell == nil) cell = [[[BirdCell alloc] init] autorelease];
        
        Bird * bird = nil; 
        
        if (columnIndex < [self.localBirds count]) {
            bird = (Bird *)[self.localBirds objectAtIndex:columnIndex];
        } else {
            bird = (Bird *)[self.remoteBirds objectAtIndex:(columnIndex -  [self.localBirds count])];
        }
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:bird.originalImagePath];
        cell.birdImage.image = image;
        [image release];
        
        return cell;
        
    } else {
        
        if (self.loadMoreCell == nil) {
            self.loadMoreCell = [[[LoadMoreCell alloc] init] autorelease];
        }
        
        return self.loadMoreCell; 
    }
   
}

@end
