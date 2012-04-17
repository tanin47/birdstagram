//
//  MenuController.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuController.h"


static MenuController *sharedInstance = nil;



@implementation MenuController


#pragma mark Singleton Methods
+ (MenuController *) singleton {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}



@synthesize imageHandler;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (imageHandler == nil) 
        imageHandler = [[ImageHandler alloc] initWithSelector:@selector(previewPhoto) 
                                                    AndTarget:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) startCamera: (id) sender
{
    [self.navigationController pushViewController:[CameraController singleton] animated:NO];
}


//- (IBAction) getPhoto: (id) sender
//{
//    //[self.navigationController pushViewController:[CameraController singleton] animated:NO];
//    [imageHandler openActionSheet];
//}
//
//
//-(void) previewPhoto
//{
//    if (imageHandler.image == nil) return;
//    
//    [PreviewController singleton].photo = [ImageHandler scaleToInstagramWithImage:imageHandler.image];
//    [imageHandler clear];
//    [self.navigationController pushViewController:[PreviewController singleton] animated:NO];
//    
//    
//}

@end
