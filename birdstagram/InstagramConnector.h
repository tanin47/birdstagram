//
//  InstagramConnector.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramConnector : NSObject


+ (UIDocumentInteractionController *) getUIDocumentInteractionControllerWithImage: (UIImage *) image
                                        WithDelegate: (id<UIDocumentInteractionControllerDelegate>) delegate;

@end
