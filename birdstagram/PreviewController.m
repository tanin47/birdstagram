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
#import "BirdOverlay.h"
#import "Bird.h"

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


@synthesize birdPanel;

@synthesize photoPath;
@synthesize previewLayer;

@synthesize instagram;

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
    self.photoPath = nil;
    self.instagram = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBirdPanel *birdPanelTmp = [[UIBirdPanel alloc] initWithFrame:CGRectMake(0, -70, 320, 70)];
    
    self.birdPanel = birdPanelTmp;
    [birdPanelTmp release];
    
    self.birdPanel.birdDelegate = self;
    [self.view addSubview:self.birdPanel];
    
    [self.birdPanel reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.birdPanel removeFromSuperview];
    self.birdPanel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *photo = [[UIImage alloc] initWithContentsOfFile:self.photoPath];
    
    DLog(@"%f %f", photo.size.width, photo.size.height);
    
    self.previewLayer.backgroundColor = [UIColor colorWithPatternImage:[ImageHandler imageWithImage:photo scaledToSize:CGSizeMake(self.previewLayer.frame.size.width, self.previewLayer.frame.size.height)]]; 
    
    [photo release];
    
    [self openBirdPanel:nil];
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.previewLayer.backgroundColor = [UIColor grayColor];
    [self.previewLayer reset];
}


- (UIImage *) getFinalImage
{
    UIImage *photo = [[UIImage alloc] initWithContentsOfFile:self.photoPath];
    
    DLog(@"Write to size: %f %f", photo.size.width, photo.size.height);
    
    UIGraphicsBeginImageContextWithOptions(photo.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [photo drawInRect:CGRectMake(0, 0, photo.size.width, photo.size.height)];
    
    CGFloat scaleX = photo.size.width / self.previewLayer.frame.size.width;
    CGFloat scaleY = photo.size.height / self.previewLayer.frame.size.height;
    
    [photo release];
    
    
    DLog(@"birds %d", [self.previewLayer.birds count]);
    
    for (BirdOverlay *bird in self.previewLayer.birds) {
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:bird.originalBirdPath];
        
        CGRect rect = CGRectMake(bird.frame.origin.x * scaleX, 
                                 bird.frame.origin.y * scaleY, 
                                 bird.frame.size.width * scaleX, 
                                 bird.frame.size.height * scaleY);
        
        
        CGContextTranslateCTM(context, (rect.origin.x + rect.size.width/2.0), (rect.origin.y + rect.size.height/2.0));
        
        CGFloat thisScaleX = scaleX * bird.frame.size.width / image.size.width;
        CGFloat thisScaleY = scaleY * bird.frame.size.height / image.size.height;
        
        CGContextScaleCTM(context, thisScaleX, thisScaleY);
        CGContextConcatCTM(context, bird.transform);
        
        
        [image drawAtPoint:CGPointMake(-image.size.width/2.0, -image.size.height/2.0)];
        
        [image release];
        
        CGContextConcatCTM(context, CGAffineTransformInvert(bird.transform));
        CGContextScaleCTM(context, 1.0 / thisScaleX, 1.0 / thisScaleY);
        CGContextTranslateCTM(context, -(rect.origin.x + rect.size.width/2.0), -(rect.origin.y + rect.size.height/2.0));
        
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (IBAction) sendToInstagram: (id) sender
{
    [DSBezelActivityView newActivityViewForView:self.view.window withLabel:@"Contacting Instagram..."];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        self.instagram = [InstagramConnector getUIDocumentInteractionControllerWithImage:[ImageHandler scaleToInstagramWithImage:[self getFinalImage]] WithDelegate:self];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [DSBezelActivityView removeViewAnimated:YES];
            [self.instagram presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
            
        });
    });

}


- (IBAction) saveToAlbum: (id) sender
{
    [DSBezelActivityView newActivityViewForView:self.view.window withLabel:@"Saving to the album..."];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *image = [self getFinalImage];
        
        image = [ImageHandler imageWithImage:image scaledToSize:CGSizeMake(image.size.width,image.size.height)];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
    });
}


- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    if (error) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Saving failed."
                                                          message:[error localizedFailureReason]
                                                         delegate:nil
                                                cancelButtonTitle:@"Close"
                                                otherButtonTitles:nil];
        [message show];
        [message release];
        return;
    }
    
    DLog(@"finalize size: %f %f", image.size.width, image.size.height);
    [self.navigationController popToRootViewControllerAnimated:NO];
}



- (IBAction) cancel: (id) sender
{
    DLog(@"");
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction) toggleBirdPanel: (id) sender
{
    if (self.birdPanel.hidden == YES) {
        [self openBirdPanel:nil];
    } else {
        [self closeBirdPanel:nil];
    }
}


- (IBAction) openBirdPanel: (id) sender
{
    self.birdPanel.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.birdPanel.frame = CGRectMake(0, 0, 320, 70);
    } completion:^ (BOOL finished){
        self.birdPanel.hidden = NO;
    }];
}


- (IBAction) closeBirdPanel: (id) sender
{
    self.birdPanel.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.birdPanel.frame = CGRectMake(0, -70, 320, 70);
    } completion:^ (BOOL finished){
        self.birdPanel.hidden = YES;
    }];
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


- (void) birdPanel: (UIBirdPanel *) birdPanel didSelectBird: (Bird *) bird
{
    BirdOverlay *birdOverlay = [[BirdOverlay alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    
    birdOverlay.originalBirdPath = bird.originalImagePath;
    
    [self.previewLayer addBird:birdOverlay];
    
    [birdOverlay release];
    [self closeBirdPanel:nil];
}



@end
