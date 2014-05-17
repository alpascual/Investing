//
//  UniqueIdentifier.h
//  Art
//
//  Created by Albert Pascual on 2/26/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniqueIdentifier : NSObject

+ (void) createNewIdentifierIfNeeded;
+ (NSString*) getUniqueIdentifier;
+ (NSString *)GetUUID;

@end
