//
//  InstagramConnector.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstagramConnector.h"

@implementation InstagramConnector


+ (UIDocumentInteractionController *) getUIDocumentInteractionControllerWithImage: (UIImage *) image
                                        WithDelegate: (id<UIDocumentInteractionControllerDelegate>) delegate
{
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [documentdir stringByAppendingPathComponent:@"shared.igo"];
    [imageData writeToFile:imagePath atomically:NO];
    
    
    UIDocumentInteractionController *instagram = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:imagePath]];
    
    instagram.UTI = @"com.instagram.exclusivegram";
    instagram.delegate = delegate;
    return instagram;
}

@end
