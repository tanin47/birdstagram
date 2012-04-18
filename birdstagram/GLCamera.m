//
//  ColorTrackingCamera.m
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/9/2010.
//

#import "GLCamera.h"


@implementation GLCamera

#pragma mark -
#pragma mark Initialization and teardown

- (id)init; 
{
    DLog(@"");
	if (!(self = [super init]))
		return nil;
	
	// Grab the back-facing camera
	AVCaptureDevice *backFacingCamera = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) 
	{
		if ([device position] == AVCaptureDevicePositionBack) 
		{
			backFacingCamera = device;
		}
	}
	
	// Create the capture session
	captureSession = [[AVCaptureSession alloc] init];
	
	// Add the video input	
	NSError *error = nil;
	videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
	if ([captureSession canAddInput:videoInput]) 
	{
		[captureSession addInput:videoInput];
	}
	
	[self videoPreviewLayer];
    
	videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	[videoOutput setAlwaysDiscardsLateVideoFrames:YES];
	[videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    videoOutput.minFrameDuration = CMTimeMake(5,1);
    [captureSession addOutput:videoOutput];
    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey]];
    [captureSession addOutput:stillImageOutput];

	
    [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];

	return self;
}

- (void) start
{
    if (![captureSession isRunning])
	{
		[captureSession startRunning];
	}
    
    isRunning = YES;
}

- (void) stop
{
    isRunning = NO;
    
    if ([captureSession isRunning])
	{
		[captureSession stopRunning];
	}
}

- (void)dealloc 
{
    DLog(@"");
    NSLog(@"Release camera %@", self);
	[self stop];
	
	[captureSession release];
	[videoPreviewLayer release];
	[videoOutput release];
    [stillImageOutput release];
	[videoInput release];
    
    captureSession = nil;
	videoPreviewLayer = nil;
	videoOutput = nil;
    stillImageOutput = nil;
	videoInput = nil;
    
	[super dealloc];
    
    NSLog(@"Succeeded releasing camera");
}


- (void) captureAndOnDone: (void(^)(UIImage *)) callback;
{
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:[stillImageOutput.connections objectAtIndex:0]
                                                  completionHandler:^(CMSampleBufferRef buffer, NSError *error) {
                                                      
                                                      if (buffer == NULL) {
                                                          return;
                                                      }
                                                          
                                                      NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buffer];
                                                  
                                                      UIImage *image = [[UIImage alloc] initWithData:imageData]; 
                                                      callback(image);
                                                      [image release];
                                                      
                                                }];
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (isRunning == NO) return;
    
	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	[self.delegate processNewCameraFrame:pixelBuffer];
}

#pragma mark -
#pragma mark Accessors

@synthesize delegate;
@synthesize videoPreviewLayer;

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer;
{
	if (videoPreviewLayer == nil)
	{
		videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
        
        if ([videoPreviewLayer isOrientationSupported]) 
		{
            [videoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        }
        
        [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	}
	
	return videoPreviewLayer;
}

@end
