//
//  SALIPLocationFinder.h
//  Address of My IP
//
//  Created by Salman Khan on 8/28/14.
//  Copyright (c) 2014 Codiodes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SALIPLocationFinder : NSObject<NSURLConnectionDelegate>

- (instancetype)initWithIPAddress:(NSString*)ipAddress;

@property(strong, nonatomic) NSURLConnection *connection;
@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic) NSURLRequest *request;
@property(strong, nonatomic) NSURLResponse *response;
@property NSMutableData *responseData;

-(NSMutableData*) getJSONData;
@end
