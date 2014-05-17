//
//  UniqueIdentifier.m
//  Art
//
//  Created by Albert Pascual on 2/26/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "UniqueIdentifier.h"

@implementation UniqueIdentifier

+ (void) createNewIdentifierIfNeeded
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"identifier"] == nil) {
        
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        
        NSString *stringWithoutSpaces = [(__bridge id)string
                                         stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [defaults setObject:stringWithoutSpaces forKey:@"identifier"];
        [defaults synchronize];
    }
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString*) getUniqueIdentifier
{
    [self createNewIdentifierIfNeeded];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"identifier"];
    //[defaults synchronize];
    return [defaults objectForKey:@"identifier"];
}

@end
