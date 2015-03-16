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
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIAlertView+Blocks.h"

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
               responseHandler:(ALResponseBlock)responseBlock{
    
    return [self pathURL:URL parameters:parameters HTTPMethod:method otherParameters:other delegate:delegate imageDict:nil completionHandler:^(id data) {
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

-(MKNetworkOperation *) pathURL:(NSString*) URL
                     parameters:(NSDictionary *) parameters
                     HTTPMethod:(NSString *)method
                otherParameters:(NSDictionary *)other
                       delegate:(id)delegate
                    imageDict:(NSDictionary *)imageDict
                responseHandler:(ALResponseBlock)responseBlock{
    
    return [self pathURL:URL parameters:parameters HTTPMethod:method otherParameters:other delegate:delegate imageDict:imageDict completionHandler:^(id data) {
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
                imageDict:(NSDictionary *)imageDict
             completionHandler:(ALCompletionBlock) completionBlock
                  errorHandler:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation *op = nil;
    
    BOOL fromData = YES;
    BOOL useToken = YES;
    
    if (other) {
        fromData = [other getBoolValueForKey:kNetworkParamKeyReturnDataFromKey defaultValue:YES];
        useToken = [other getBoolValueForKey:kNetworkParamKeyUseToken defaultValue:YES];
    }
    
    if ([JRUser isLogin] && useToken) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [param setValue:[JRUser currentUser].guid forKey:@"guid"];
        [param setValue:[JRUser currentUser].token forKey:@"token"];
//        [param setValue:@"75CE5431E086E3CAD2C6757EC8E8F80B" forKey:@"guid"];
//        [param setValue:@"7B9A456C628C91D4B0BFC8D6D94A7E7A" forKey:@"token"];
        parameters = param;
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
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];

    
    [imageDict.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        id data = [imageDict objectForKey:key];
        if ([data isKindOfClass:[NSData class]]) {
            [op addData:data forKey:key mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg",key]];
        }else if ([data isKindOfClass:[UIImage class]]){
            [op addData:UIImageJPEGRepresentation(data, 1.0) forKey:key mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg",key]];
        }
        
    }];
    
    if (delegate) {
        op.className = NSStringFromClass([delegate class]);
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
//        ASLog(@"allHeaderFields:%@",[completedOperation.readonlyResponse allHeaderFields]);
        
        NSString *resultString = completedOperation.responseString;
        NSLog(@"Network Success:\n%@ \n %@ \n%@",completedOperation.url,parameters,resultString);

        id result = completedOperation.responseJSON;
        if (result) {
            if (!fromData) {
                completionBlock(result);
                return;
            }
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *body = [result objectForKey:@"respBody"];
                NSDictionary *header = [result objectForKey:@"respHead"];
                if (header && [header isKindOfClass:[NSDictionary class]]) {
                    if ([[[header getStringValueForKey:@"respCode" defaultValue:@""] uppercaseString] isEqualToString:@"OK"]) {
                        completionBlock(body);
                    }else if([[[header getStringValueForKey:@"respCode" defaultValue:@""] uppercaseString] isEqualToString:@"TL"]){
                        LoginViewController *login = [[LoginViewController alloc] init];
                        UINavigationController *loginNav = [Public navigationControllerFromRootViewController:login];
                        [[(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController] presentViewController:loginNav animated:YES completion:nil];
                        
                        NSError *err = [[NSError alloc] initWithDomain:@"" code:100 userInfo:@{NSLocalizedDescriptionKey:[header getStringValueForKey:@"respShow" defaultValue:@""]}];
                        errorBlock(err);
                    }else{
                        NSError *err = [[NSError alloc] initWithDomain:@"" code:100 userInfo:@{NSLocalizedDescriptionKey:[header getStringValueForKey:@"respShow" defaultValue:@""]}];
                        errorBlock(err);
                    }
                }else{
                    NSError *err = [[NSError alloc] initWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@""}];
                    errorBlock(err);
                }
                
            }else{
                NSError *err = [[NSError alloc] initWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@""}];
                errorBlock(err);
            }
            
        }else{
            NSError *err = [[NSError alloc] initWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@""}];
            errorBlock(err);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSError *err = [[NSError alloc] initWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@""}];
        errorBlock(err);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (void)showErrMsg:(NSError *)err{
    NSString *msg = nil;
    if (err == nil || err.localizedDescription.length == 0) {
        msg = @"网络异常请稍后再试";
    }else{
        msg = err.localizedDescription;//[NSString stringWithFormat:@"%d,%@",err.code,err.localizedDescription];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GlobalPopupAlert show:msg andFadeOutAfter:2];
    });
    
//    [self performSelector:@selector(showTip:) withObject:msg afterDelay:.3];
    
}

- (void)showTip:(NSString *)msg{
    [GlobalPopupAlert show:msg andFadeOutAfter:1.5];
}

@end
