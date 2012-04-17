//
//  PreviewController.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreviewController.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>


static PreviewController *sharedInstance = nil;


@implementation PreviewController


#pragma mark Singleton Methods
+ (PreviewController *) singleton {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}


@synthesize photo;
@synthesize birdLayer;
@synthesize previewLayer;

@synthesize originalBird;
@synthesize originalBirdSize;
@synthesize instagram;

@synthesize x;
@synthesize y;
@synthesize clockwiseAngle;
@synthesize scale;


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
    
    self.birdLayer.image = originalBird;
    self.birdLayer.frame = CGRectMake(self.birdLayer.center.x - self.originalBirdSize.width/2.0,
                                      self.birdLayer.center.y - self.originalBirdSize.height/2.0,
                                      self.originalBirdSize.width,
                                      self.originalBirdSize.height);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    self.photo = nil;
    self.instagram = nil;
    self.originalBird = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.originalBird = [UIImage imageNamed:@"bird.png"];

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


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize size = [self.photo size];
    NSLog(@"%f %f", size.width, size.height);
    
    
    int maxWidth = self.previewLayer.frame.size.width;
    int maxHeight = self.previewLayer.frame.size.height;
    
    int newHeight = maxHeight;
    int newWidth = size.width * newHeight / size.height;
    
    if (newWidth > maxWidth) {
        newWidth = maxWidth;
        newHeight = size.height * newWidth / size.width;
    }
    
//    self.previewLayer.frame = CGRectMake((320 - newWidth) / 2, (400 - newHeight) / 2, newWidth, newHeight);
    
    NSLog(@"%f %f %f %f", self.previewLayer.frame.origin.x,
                            self.previewLayer.frame.origin.y,
                            self.previewLayer.frame.size.width,
                            self.previewLayer.frame.size.height);
    
    self.previewLayer.backgroundColor = [UIColor colorWithPatternImage:[ImageHandler imageWithImage:self.photo scaledToSize:CGSizeMake(newWidth, newHeight)]]; 
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.previewLayer.backgroundColor = [UIColor grayColor]; 
}



- (IBAction) confirm: (id) sender
{
    [DSBezelActivityView newActivityViewForView:self.view.window withLabel:@"Contacting Instagram..."];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"%f %f %f %f %f %f", self.birdLayer.transform.a,
                                    self.birdLayer.transform.b,
                                    self.birdLayer.transform.c,
                                    self.birdLayer.transform.d,
                                    self.birdLayer.transform.tx,
                                    self.birdLayer.transform.ty);
        
        
        NSLog(@"Bird's dimension: %f %f", self.birdLayer.frame.size.width, self.birdLayer.frame.size.height);
        
        NSLog(@"Bird's position %f %f", self.birdLayer.center.x, self.birdLayer.center.y);
        
        
        UIGraphicsBeginImageContextWithOptions(self.photo.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.photo drawInRect:CGRectMake(0, 0, self.photo.size.width, self.photo.size.height)];
        
        
        CGFloat scaleX = self.photo.size.width / self.previewLayer.frame.size.width;
        CGFloat scaleY = self.photo.size.height / self.previewLayer.frame.size.height;
        
        CGRect rect = CGRectMake(self.birdLayer.frame.origin.x * scaleX, 
                                self.birdLayer.frame.origin.y * scaleY, 
                                self.birdLayer.frame.size.width * scaleX, 
                                self.birdLayer.frame.size.height * scaleY);
        
        
        CGContextTranslateCTM(context, (rect.origin.x + rect.size.width/2.0), (rect.origin.y + rect.size.height/2.0));
        CGContextScaleCTM(context, 
                        self.originalBirdSize.width / self.originalBird.size.width, 
                        self.originalBirdSize.height / self.originalBird.size.height);
        CGContextScaleCTM(context, scaleX, scaleY);
        CGContextConcatCTM(context, self.birdLayer.transform);
        
        
        [self.originalBird drawAtPoint:CGPointMake(-self.originalBird.size.width/2.0, -self.originalBird.size.height/2.0)];
     
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.instagram = [InstagramConnector getUIDocumentInteractionControllerWithImage:newImage WithDelegate:self];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [DSBezelActivityView removeViewAnimated:YES];
            [self.instagram presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
            
        });
    });

}


- (IBAction) cancel: (id) sender
{
    DLog(@"");
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark Document Interaction Controller Delegate Methods

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}


- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
