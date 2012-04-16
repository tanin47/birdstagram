//
//  PreviewController.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreviewController.h"
#import <QuartzCore/QuartzCore.h>


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
@synthesize bird;
@synthesize previewLayer;

@synthesize x;
@synthesize y;
@synthesize clockwiseAngle;
@synthesize scale;


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
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    
    
    int maxWidth = 320;
    int maxHeight = 400;
    
    int newHeight = maxHeight;
    int newWidth = size.width * newHeight / size.height;
    
    if (newWidth > maxWidth) {
        newWidth = maxWidth;
        newHeight = size.height * newWidth / size.width;
    }
    
    self.previewLayer.frame = CGRectMake((320 - newWidth) / 2, (400 - newHeight) / 2, newWidth, newHeight);
    
    self.previewLayer.backgroundColor = [UIColor colorWithPatternImage:[ImageHandler imageWithImage:self.photo scaledToSize:CGSizeMake(newWidth, newHeight)]]; 
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.previewLayer.backgroundColor = [UIColor grayColor]; 
}



- (IBAction) confirm: (id) sender
{
    [DSBezelActivityView newActivityViewForView:self.view.window withLabel:@"Saving the photo..."];
    
    
    NSLog(@"%f %f %f %f %f %f", self.bird.transform.a,
                                self.bird.transform.b,
                                self.bird.transform.c,
                                self.bird.transform.d,
                                self.bird.transform.tx,
                                self.bird.transform.ty);
    
    
    NSLog(@"Bird's dimension: %f %f", self.bird.frame.size.width, self.bird.frame.size.height);
    
    NSLog(@"Bird's position %f %f", self.bird.center.x, self.bird.center.y);
    
    
    UIGraphicsBeginImageContextWithOptions(self.photo.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.photo drawInRect:CGRectMake(0, 0, self.photo.size.width, self.photo.size.height)];
    
    
    CGFloat scaleX = self.photo.size.width / self.previewLayer.frame.size.width;
    CGFloat scaleY = self.photo.size.height / self.previewLayer.frame.size.height;
    
    CGRect rect = CGRectMake(self.bird.frame.origin.x * scaleX, 
                                  self.bird.frame.origin.y * scaleY, 
                                  self.bird.frame.size.width * scaleX, 
                                  self.bird.frame.size.height * scaleY);
    
    NSLog(@"%f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    
    UIImage *scaledBird = [ImageHandler imageWithImage:self.bird.image scaledToSize:rect.size];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, (rect.origin.x + rect.size.width/2.0), (rect.origin.y + rect.size.height/2.0));
    transform = CGAffineTransformConcat(transform, self.bird.transform);
    
    CGContextConcatCTM(context, transform);


    CGRect originRect = CGRectMake(- rect.size.width/2.0,
                                   - rect.size.height/2.0,
                                   rect.size.width/2.0,
                                   rect.size.height/2.0);
    
    CGContextDrawImage(context, originRect, scaledBird.CGImage);

    transform = CGAffineTransformTranslate(transform, -(rect.origin.x + rect.size.width/2.0), -(rect.origin.y + rect.size.height/2.0));
    
    CGContextConcatCTM(context, transform);
   
    //[scaledBird drawInRect:originRect];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}


- (IBAction) cancel: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Saving the photo failed"
                                                          message:[error localizedFailureReason]
                                                         delegate:nil
                                                cancelButtonTitle:@"Close"
                                                otherButtonTitles:nil];
        [message show];
        [message release];
        return;
    }

    
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
