//
//  CameraController.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraController.h"
#import "PreviewController.h"


static CameraController *sharedInstance = nil;

@implementation CameraController



#pragma mark Singleton Methods
+ (CameraController *) singleton {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}




@synthesize previewLayer;
@synthesize camera;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        GLCamera *cameraTmp = [[GLCamera alloc] init];
        self.camera = cameraTmp;
        [cameraTmp release];
        
        self.camera.delegate = self;
        [self cameraHasConnected];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    DLog(@"");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    DLog(@"");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.camera = nil;
    DLog(@"End");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];
    [self.camera start];
    
    [self.previewLayer.layer addSublayer:self.camera.videoPreviewLayer];
    
    CGRect bounds = self.previewLayer.layer.bounds;
    self.camera.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.camera.videoPreviewLayer.bounds = bounds;
    self.camera.videoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void) viewDidDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewDidDisappear:animated];
    //[self.camera stop];
    [self.camera.videoPreviewLayer removeFromSuperlayer];
}


- (IBAction) capturePhoto: (id) sender
{
    capturePhotoNow = YES;
}


#pragma mark -
#pragma mark ColorTrackingCameraDelegate methods

- (void)cameraHasConnected
{
	NSLog(@"Connected to camera");
	/*	camera.videoPreviewLayer.frame = self.view.bounds;
	 [self.view.layer addSublayer:camera.videoPreviewLayer];*/
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
UIImage* rotateAndMakeSquare(UIImage* src, UIImageOrientation orientation)
{
    CGFloat sideLength = (src.size.width < src.size.height) ? src.size.width : src.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(sideLength, sideLength));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, sideLength/2.0, sideLength/2.0);
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(-src.size.width/2.0, -src.size.height/2.0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}


- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame
{
	if (capturePhotoNow == YES)
    {
        UIImage *image = rotateAndMakeSquare([self processNewCameraFrameWithC:cameraFrame], UIImageOrientationUp);
        
        [PreviewController singleton].photo = image;
        [self.navigationController pushViewController:[PreviewController singleton] animated:NO];
        
        capturePhotoNow = NO;
    }
}


- (UIImage *) processNewCameraFrameWithC: (CVImageBufferRef) cameraFrame
{
	CVPixelBufferLockBaseAddress(cameraFrame, 0);
    
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(cameraFrame); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(cameraFrame); 
    size_t width = CVPixelBufferGetWidth(cameraFrame); 
    size_t height = CVPixelBufferGetHeight(cameraFrame); 
    
    //reference_convert(baseAddress, baseAddress, width, height);
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    

    CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
    
    UIImage *image = [UIImage imageWithCGImage:newImage];

	
    /*We release some components*/
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);
	
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
    
    return image;
}


@end
