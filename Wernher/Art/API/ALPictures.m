//
//  ALPictures.m
//  Art
//
//  Created by Albert Pascual on 2/19/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ALPictures.h"

//You can start with this one:
//http://dev.leonar.do/api/v1/art/pinterest/?count=50&c=3&json=1
//
//You can omit the 'json=1' in code -- that just forces json in a browser. Keep the  c=3 in there, just found a bug that occurs if you don't provide ANY feature-filters.
//
//To support the app, I need to do these things:
//1) add a "start time" parameter
//2) hook it up to the pinterest art-category 'firehose'
//3) sort by date

@implementation ALPictures

//http://dev.leonar.do/api/v1/art/pinterest/?json=1&up_to=1372652470&count=20
//http://dev.leonar.do/api/v1/art/pins/?count=50


- (NSString*) tastePin
{
    //http://dev.leonar.do/api/v1/tastes/pins
    
    NSString *response = [self makeRequest:@"http://dev.leonar.do/api/v1/tastes/pins"];
    
    return response;
}

- (BOOL) like:(NSString*)lid
{
    //http://dev.leonar.do/api/v1/post/art/pins/likes/SR14MmdEIbEPaevqjXOMS1/
    
    NSString *myLikedPictures = [[NSString alloc] initWithFormat:@"http://dev.leonar.do/api/v1/post/art/pins/likes/%@", lid];
    
    NSString * response = [self makeRequest:myLikedPictures];
    //NSLog(@"Ignoring response right now %@", response);
    
    return YES;
}

- (BOOL) dismiss:(NSString*)lid
{
    //http://dev.leonar.do/api/v1/art/pins/dismissed/?lid=1234
    
    NSString *myDismissPictures = [[NSString alloc] initWithFormat:@"http://dev.leonar.do/api/v1/art/pins/dismissed/?lid=%@", lid];
    
    NSString * response = [self makeRequest:myDismissPictures];
    //NSLog(@"Ignoring response right now %@", response);
    
    return YES;
}

- (NSArray*) getPicturesWithTime:(NSInteger)howMany timestamp:(NSInteger)stamp
{
    NSString *myRequestPictures = [[NSString alloc] initWithFormat:@"http://dev.leonar.do/api/v1/art/pins/?count=%ld&json=1", (long)howMany];
    
    if ( stamp > 0 )
        myRequestPictures = [[NSString alloc] initWithFormat:@"http://dev.leonar.do/api/v1/art/pins/?count=%ld&json=1&up_to=%ld", (long)howMany, (long)stamp];
    
    NSString * response = [self makeRequest:myRequestPictures];
    
    NSError *error;
    // AL Bookmark
    NSDictionary *theDictionary = [NSDictionary dictionaryWithJSONString:response error:&error];
    NSArray *array = (NSArray*)theDictionary;
    /*NSMutableArray *arrayToReturn = [[NSMutableArray alloc] init];
    for(int i=0; i < array.count; i++) {
        
        NSDictionary *item = [array objectAtIndex:i];
        
        // AL Bookmark
        //get the image and store it!
        ALPictureItem *itemPicture = [ALPictureParser parsePicture:item];
        [arrayToReturn addObject:itemPicture];
        
        // Request the image and get the data
        ALPictures *pic = [[ALPictures alloc] init];
        NSData *dataForPic = [pic getImageData:itemPicture.thumb];
        
        //NSLog(@"Adding image for URL %@", itemPicture.thumb);
        [[ALImagesCache sharedCache] addImage:itemPicture.thumb withData:dataForPic];
        
        
    }
    
    return arrayToReturn;*/
    return array;
}

- (void) getMorePictures:(NSInteger)howMany
{
    
    dispatch_queue_t builder = dispatch_queue_create("builder", NULL);
    dispatch_async(builder,
                   ^{
                       ALPictureParser *parser = [[ALPictureParser alloc] init];
                       NSString *timestampString = [parser getLastTimeStamp];
                       NSArray *moreArrayList = [self getPicturesWithTime:howMany timestamp:[timestampString intValue]];
                       [[ALImagesCache sharedCache] addList:moreArrayList];
                       
                       // Fetch all the new images
                       for (int i=0; i < moreArrayList.count; i++) {
                           
                           NSDictionary *dic = [moreArrayList objectAtIndex:i];
                           ALPictureItem *item = [ALPictureParser parsePicture:dic];
                           NSData *dataForPic = [self getImageData:item.thumb];
                           [[ALImagesCache sharedCache] addImage:item.thumb withData:dataForPic];
                       }
                       
                       ALPictureCache *cache = [[ALPictureCache alloc] init];
                       [cache generateRequestAndCacheAll];
                   });
    
    
}

- (NSArray*) getPictures:(NSInteger)howMany
{
    NSArray *list = [[ALImagesCache sharedCache] getCachedList];
    if (list == nil)
        return [self getPicturesWithTime:howMany timestamp:0];
    
    // Get more pictures in the background TODO test
    dispatch_queue_t builder = dispatch_queue_create("builder", NULL);
    dispatch_async(builder,
                   ^{
                       ALPictureParser *parser = [[ALPictureParser alloc] init];
                       NSString *timestampString = [parser getLastTimeStamp];
                       NSArray *moreArrayList = [self getPicturesWithTime:50 timestamp:[timestampString intValue]];
                       [[ALImagesCache sharedCache] addList:moreArrayList];
                       
                       // Fetch all the new images
                       for (int i=0; i < moreArrayList.count; i++) {
                       
                           NSDictionary *dic = [moreArrayList objectAtIndex:i];
                           ALPictureItem *item = [ALPictureParser parsePicture:dic];
                           NSData *dataForPic = [self getImageData:item.thumb];
                           [[ALImagesCache sharedCache] addImage:item.thumb withData:dataForPic];
                       }
                   });
    
    return list;
}

- (NSString*) makeRequest:(NSString*)requestString
{
    //NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    NSString *userName = [UniqueIdentifier getUniqueIdentifier];
    NSString *password = @"6d11ecf6-9f2d-11e3-82d5-6480991abd18";
    
    
    // create a plaintext string in the format username:password
    NSMutableString *loginString = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", userName, password];
    
    
    // employ the Base64 encoding above to encode the authentication tokens
    NSString *encodedLoginData = [ALPictures encode:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // create the contents of the header
    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:requestString]
                                                           cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval: 30];
    
    // add the header to the request.  Here's the $$$!!!
    [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSData *response2 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:response2 encoding:NSUTF8StringEncoding];
    
    //NSLog(@" Response %@", responseString);
    
//    if ( responseString.length == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Problems connecting to the internet, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
    
    return responseString;
}


static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+(NSString *)encode:(NSData *)plainText {
    int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
    unsigned char *outputBuffer = malloc(encodedLength);
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
    
    NSInteger i;
    NSInteger j = 0;
    int remain;
    
    for(i = 0; i < [plainText length]; i += 3) {
        remain = [plainText length] - i;
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
        
        if(remain > 1)
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        else
            outputBuffer[j++] = '=';
        
        if(remain > 2)
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        else
            outputBuffer[j++] = '=';
    }
    
    outputBuffer[j] = 0;
    
    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];
    free(outputBuffer);
    
    return result;
}

- (NSData*)getImageData:(NSString*)imageUrl
{
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
}

@end
