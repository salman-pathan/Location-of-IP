//
//  SALIPLocationFinder.m
//  Address of My IP
//
//  Created by Salman Khan on 8/28/14.
//  Copyright (c) 2014 Codiodes. All rights reserved.
//

#import "SALIPLocationFinder.h"
#import "SALAppConstants.h"

NSString const *baseURL = @"http://freegeoip.net/json/";

@implementation SALIPLocationFinder

- (instancetype)initWithIPAddress:(NSString*)ipAddress
{
    self = [super init];
    if (self && ipAddress) {
        @try {
            //Appending IP Address to Base URL
            NSString *modifiedURL = [baseURL stringByAppendingString:(NSString*)ipAddress];
            
            //Initialize NSURL Object with appended IP Address to the base URL
            _url = [[NSURL alloc]initWithString:(NSString*)modifiedURL];
            
            //Create Network Request
            _request = [[NSURLRequest alloc]initWithURL:self.url];
            _connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        @finally {
            
        }
    }
    return self;
}

-(NSMutableData*) getJSONData {
    return self.responseData;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"%lu bytes of data received",(unsigned long)[self.responseData length]);
    
    // Dictionay for sending data in notification
    NSDictionary *userInfoForNotification = @{kcDictionayKeyResponseData:self.responseData};
    
    //  Send Notification when all the data loads succesfully.
    [[NSNotificationCenter defaultCenter]postNotificationName:(NSString*)kcNotificationResponseData
                                                       object:nil
                                                     userInfo:userInfoForNotification];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
}

@end
