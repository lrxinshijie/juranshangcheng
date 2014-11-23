//
//  GoomeEngine.h
//  BusOnline
//
//  Created by Kowloon on 13-6-18.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "MKNetworkEngine.h"

#define kNetworkParamKeyShowErrorDefaultMessage @"showErrorDefaultMessage"
#define kNetworkParamKeyCancelOperationsFromURL @"CancelOperationsFromURL"
#define kNetworkParamKeyReturnDataFromKey       @"ReturnDataFromKey"

static NSString * const kNetworkDataKey                  = @"data";
static NSString * const kNetworkSuccessKey               = @"status";
static NSString * const kNetworkMessageKey               = @"msg";
static NSString * const kNetworkErrorCodeKey             = @"errcode";

@class BCImage;

@interface ALEngine : MKNetworkEngine

typedef void (^CompletionBlock)(id data);

typedef void (^ResponseBlock)(NSError* error, id data, NSDictionary *other);

- (id)initWithDefaultSettings;

+ (ALEngine *)shareEngine;

-(MKNetworkOperation *) pathURL:(NSString*) URL
                    parameters:(NSDictionary *) parameters
                    HTTPMethod:(NSString *)method
               otherParameters:(NSDictionary *)other
                      delegate:(id)delegate
            responseHandler:(ResponseBlock)responseBlock;

- (MKNetworkOperation *) pathURL:(NSString*) URL
                      parameters:(NSDictionary *) parameters
                      HTTPMethod:(NSString *) method
                 otherParameters:(NSDictionary *)other
                        delegate:(id)delegate
                      imageDatas:(NSArray *)imageDatas
                 responseHandler:(ResponseBlock)responseBlock;

+ (void) cancelOperationsWithClass:(id)Class;

@end
