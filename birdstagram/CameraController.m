//
//  CameraController.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraController.h"


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
    
    self.camera = [[GLCamera alloc] init];
	[self.camera release];
	
	self.camera.delegate = self;
	[self cameraHasConnected];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.camera = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ColorTrackingCameraDelegate methods

- (void)cameraHasConnected
{
	NSLog(@"Connected to camera");
	/*	camera.videoPreviewLayer.frame = self.view.bounds;
	 [self.view.layer addSublayer:camera.videoPreviewLayer];*/
}

- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame
{
	[self processNewCameraFrameWithC:cameraFrame];
}


static void reference_convert (uint8_t* dest, uint8_t* src, int w, int h)
{
    int i;
    int r,g,b;
    int y;
    int n = w*h;
    
    for (i=0; i < n; i++)
    {
        b = *src++; // load blue
        g = *src++; // load green
        r = *src++; // load red
        src++; // skip aplha
        
        // build weighted average:
        y = ((r*77)+(g*151)+(b*28))>>8;
        
        // undo the scale by 256 and write to memory:
        *dest++ = y;
        *dest++ = y;
        *dest++ = y;
        dest++;
    }
}

- (void) processNewCameraFrameWithC: (CVImageBufferRef) cameraFrame
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
	
    /*We release some components*/
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);
    
    /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	[self.previewLayer.layer performSelectorOnMainThread:@selector(setContents:) withObject: (id) newImage waitUntilDone:YES];
	
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
}


@end
