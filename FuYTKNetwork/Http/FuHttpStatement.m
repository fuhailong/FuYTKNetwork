//
//  FuHttpStatement.m
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "FuHttpStatement.h"
#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFSecurityPolicy.h>
#import "NSString+FuAdd.h"

#define httpInfo(c, u, t, m) {\
FuHttpInfo *info = [[FuHttpInfo alloc] initWithInfo:c url:u type:t method:m];\
if (info != nil) {\
[dict setObject:info forKey:[info dictKey]];\
}\
}

@interface FuHttpStatement ()
@property (nonatomic, strong) NSDictionary *httpInfos;
@end

@implementation FuHttpStatement

+ (FuHttpStatement *)shared {
    static FuHttpStatement *method = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method = [[FuHttpStatement alloc] init];
    });
    return method;
}

- (id)init {
    self = [super init];
    if (self) {
        //初始化ytk配置
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        /*
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"pem"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        config.securityPolicy.allowInvalidCertificates = YES;
        config.securityPolicy.validatesDomainName = NO;
        config.securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
        */
        config.baseUrl = @"baseUrl";
        
        //加载所有方法函数
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:FU_HTTP_END];
        {
            httpInfo(@"MData1Model", @"pricelive/list", FU_HTTP_GET_DATA, FU_HTTP_GET);
        }
        self.httpInfos = [NSDictionary dictionaryWithDictionary:dict];
        dict = nil;
    }
    return self;
}

- (NSString *)typeClassName:(FuHttpType)type {
    NSString *key = [NSString stringWithFormat:@"%@%@", FuHttpInfoKey, @(type)];
    if ([self.httpInfos.allKeys containsObject:key]) {
        FuHttpInfo *info = [self.httpInfos objectForKey:key];
        return info.className;
    }
    return nil;
}

- (Class)typeClass:(FuHttpType)type {
    NSString *className = [self typeClassName:type];
    if (IsEmpty(className)) {
        return NSClassFromString(className);
    }
    return nil;
}

- (NSString *)requestUrl:(FuHttpType)type {
    NSString *key = [NSString stringWithFormat:@"%@%@", FuHttpInfoKey, @(type)];
    if ([self.httpInfos.allKeys containsObject:key]) {
        FuHttpInfo *info = [self.httpInfos objectForKey:key];
        return info.url;
    }
    return nil;
}

- (FuHttpMethod)method:(FuHttpType)type {
    NSString *key = [NSString stringWithFormat:@"%@%@", FuHttpInfoKey, @(type)];
    if ([self.httpInfos.allKeys containsObject:key]) {
        FuHttpInfo *info = [self.httpInfos objectForKey:key];
        return info.method;
    }
    return FU_HTTP_GET;
}

@end
