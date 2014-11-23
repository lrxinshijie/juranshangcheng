//
//  GoomeEngine.m
//  BusOnline
//
//  Created by Kowloon on 13-6-18.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "ALEngine.h"
#import "GlobalPopupAlert.h"
#import "NSDictionary+ASCategory.h"
//#import "User.h"

@interface ALEngine ()

@end

@implementation ALEngine

- (id)initWithDefaultSettings{
    self = [super initWithHostName:@"" apiPath:@"" customHeaderFields:nil];
//    self = [super init];
    
    if(self) {
        
    }
    
    return self;
}

+ (ALEngine *)shareEngine{
    static ALEngine *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultSettings];
    });
    
    return sharedInstance;
}

-(MKNetworkOperation *) pathURL:(NSString*) URL
                    parameters:(NSDictionary *) parameters
                    HTTPMethod:(NSString *)method
               otherParameters:(NSDictionary *)other
                      delegate:(id)delegate
               responseHandler:(ResponseBlock)responseBlock{
    
    return [self pathURL:URL parameters:parameters HTTPMethod:method otherParameters:other delegate:delegate completionHandler:^(id data) {
        responseBlock(nil,data,nil);
    } errorHandler:^(NSError *error) {
        if (other) {
            BOOL isShow = [other getBoolValueForKey:kNetworkParamKeyShowErrorDefaultMessage defaultValue:YES];
            if (isShow) {
                [self showErrMsg:error];
            }
        }else{
            [self showErrMsg:error];
        }
        
        
        responseBlock(error,nil,nil);
    }];
    
}

+ (void) cancelOperationsWithClass:(id)Class{
    [self cancelOperationsMatchingBlock:^BOOL (MKNetworkOperation* op) {
        return [op.className isEqualToString:NSStringFromClass([Class class])];
    }];
}

- (MKNetworkOperation *) pathURL:(NSString*) URL
                    parameters:(NSDictionary *) parameters
                    HTTPMethod:(NSString *) method
               otherParameters:(NSDictionary *) other
                      delegate:(id)delegate
             completionHandler:(CompletionBlock) completionBlock
                  errorHandler:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation *op = nil;
    
    BOOL fromData = YES;
    
    if (other) {
        fromData = [other getBoolValueForKey:kNetworkParamKeyReturnDataFromKey defaultValue:YES];
    }
    
    if ([URL rangeOfString:@"http"].location == NSNotFound) {
        op = [self operationWithPath:URL
                              params:parameters
                          httpMethod:method];
    }else{
        op = [self operationWithURLString:URL
                                   params:parameters
                               httpMethod:method];
    }
    
    [op addHeader:@"Accept-Encoding" withValue:@"gzip"];
    
//    if ([User isLogin]) {
//        [op setHeader:@"member_id" withValue:[NSString stringWithFormat:@"%d",[User currentUser].member_id]];
//    }
    [op setHeader:@"token" withValue:@"kXg7C5oXKZT3I"];
    
    if (delegate) {
        op.className = NSStringFromClass([delegate class]);
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
//        ASLog(@"allHeaderFields:%@",[completedOperation.readonlyResponse allHeaderFields]);
        
        NSString *resultString = completedOperation.responseString;
        NSLog(@"Network Success:\n%@,Result:\n%@",completedOperation.url,resultString);

        id result = completedOperation.responseJSON;
        if (result) {
            if (!fromData) {
                completionBlock(result);
                return;
            }
            if ([result isKindOfClass:[NSDictionary class]]) {
                id data = [result objectForKey:kNetworkDataKey];
                if ([[result objectForKey:@"success"] boolValue]) {
                    completionBlock(data);
                }else{
                    NSError *err = [[NSError alloc] initWithDomain:@"" code:[[result objectForKey:@"retcode"] intValue] userInfo:@{NSLocalizedDescriptionKey:[result objectForKey:@"msg"]}];
                    errorBlock(err);
                }
            }else{
                NSError *err = [[NSError alloc] initWithDomain:@"" code:[[result objectForKey:@"retcode"] intValue] userInfo:@{NSLocalizedDescriptionKey:@""}];
                errorBlock(err);
            }
            
        }else{
            NSError *err = [[NSError alloc] initWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@""}];
            errorBlock(err);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark - 图片上传

- (MKNetworkOperation *) pathURL:(NSString*) URL
                      parameters:(NSDictionary *) parameters
                      HTTPMethod:(NSString *) method
                 otherParameters:(NSDictionary *)other
                        delegate:(id)delegate
                       imageDatas:(NSArray *)imageDatas
               responseHandler:(ResponseBlock)responseBlock{
    
    BOOL fromData = YES;
    BOOL showMsg = YES;
    
    if (other) {
        showMsg = [other getBoolValueForKey:kNetworkParamKeyShowErrorDefaultMessage defaultValue:YES];
        fromData = [other getBoolValueForKey:kNetworkParamKeyReturnDataFromKey defaultValue:YES];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    MKNetworkOperation *op = nil;
    
    
    
    NSString *URLString = URL;
    
    if ([URLString rangeOfString:@"http"].location == NSNotFound) {
        op = [self operationWithPath:URLString
                              params:params
                          httpMethod:method];
    }else{
        op = [self operationWithURLString:URLString
                                   params:params
                               httpMethod:method];
    }
    
    [op addHeader:@"Accept-Encoding" withValue:@"gzip"];
    
    [imageDatas enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
        if (data && data.length > 0) {
            [op addData:data forKey:[NSString stringWithFormat:@"image[%d]",idx+1] mimeType:@"image/jpeg" fileName:@"pic0.jpg"];
        }
    }];

    
    
//    if ([User isLogin]) {
//        [op setHeader:@"user_id" withValue:[NSString stringWithFormat:@"%d",[User currentUser].user_id]];
//    }
//    [op setHeader:@"token" withValue:@"kXg7C5oXKZT3I"];
    
    [op onUploadProgressChanged:^(double progress) {
        ASLog(@"progress:%f",progress);
    }];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *resultString = completedOperation.responseString;
        BOOL showError = YES;
        NSInteger errcode = 0;
        NSString *errmsg = @"";
        ASLog(@"Network Success:\n%@,Result:\n%@",completedOperation.url,resultString);
        if (resultString.length > 0) {
            
            NSError *error = nil;
            id result = completedOperation.responseJSON;
            if (result && error == nil) {
                
                if (!fromData) {
                    responseBlock(nil, result, nil);
                    return;
                }
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    if ([result getBoolValueForKey:@"success" defaultValue:NO]) {
                        id data = [result objectForKey:kNetworkDataKey];
                        responseBlock(nil, data, nil);
                    }else{
                        errcode = [result getIntValueForKey:@"errcode" defaultValue:0];
                        errmsg = [result getStringValueForKey:@"msg" defaultValue:@""];
                    }
                }
            }else{
//                [self sendNetworkError:[NSString stringWithFormat:@"%@ JSON Error",[self baseURL:completedOperation]]];
            }
            
        }else{
//            [self sendNetworkError:@"Response NULL"];
        }
        
        if (showError) {
            NSError *err = [[NSError alloc] initWithDomain:@"" code:errcode userInfo:@{NSLocalizedDescriptionKey: errmsg}];
            responseBlock(err, nil, nil);
            if (showMsg) {
//                [self showErrMsg:err URLString:URLString];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        //        if (isSend) {
        //            [Public endEvent:kUMEventNetworkDuration label:label];
        //        }
        
        ASLog(@"Network Error:%@,%@",completedOperation.url,error);
        
//        [self sendNetworkError:[NSString stringWithFormat:@"%@ %d %@ ",[self baseURL:completedOperation],error.code, error.localizedDescription]];
        
        responseBlock(error,nil, nil);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (void)showErrMsg:(NSError *)err{
    NSString *msg = nil;
    if (err == nil || err.localizedDescription.length == 0) {
        msg = @"Your internet connection is lost";
    }else{
        msg = err.localizedDescription;//[NSString stringWithFormat:@"%d,%@",err.code,err.localizedDescription];
    }
    
    [self performSelector:@selector(showTip:) withObject:msg afterDelay:.3];
    
}

- (void)showTip:(NSString *)msg{
    [GlobalPopupAlert show:msg andFadeOutAfter:1.5];
}

@end
