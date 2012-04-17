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
	// Add the video frame output	
	videoOutput = [[AVCaptureVideoDataOutput alloc] init];

	[videoOutput setAlwaysDiscardsLateVideoFrames:YES];
	// Use RGB frames instead of YUV to ease color processing
	[videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
	//	dispatch_queue_t videoQueue = dispatch_queue_create("com.sunsetlakesoftware.colortracking.videoqueue", NULL);
	//	[videoOutput setSampleBufferDelegate:self queue:videoQueue];
	
	//	dispatch_queue_t videoQueue = dispatch_queue_create("com.sunsetlakesoftware.colortracking.videoqueue", NULL);
	[videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    videoOutput.minFrameDuration = CMTimeMake(5,1);

	
	if ([captureSession canAddOutput:videoOutput])
	{
		[captureSession addOutput:videoOutput];
	}
	else
	{
		NSLog(@"Couldn't add video output");
	}
	
	// Start capturing
    
    [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    //[captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    //[captureSession setSessionPreset:AVCaptureSessionPreset640x480];
	//[self start];
	
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
	[videoInput release];
    
    captureSession = nil;
	videoPreviewLayer = nil;
	videoOutput = nil;
	videoInput = nil;
    
	[super dealloc];
    
    NSLog(@"Succeeded releasing camera");
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
