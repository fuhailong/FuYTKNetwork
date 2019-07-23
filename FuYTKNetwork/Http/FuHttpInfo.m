//
//  FuHttpInfo.m
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "FuHttpInfo.h"

@interface FuHttpInfo ()
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, assign) FuHttpMethod method;
@end

@implementation FuHttpInfo

- (id)initWithInfo:(nonnull NSString *)className url:(nonnull NSString *)url type:(FuHttpType)type method:(FuHttpMethod)method {
    self = [super init];
    if (self) {
        self.className = className;
        self.url = url;
        self.type = @(type);
        self.method = method;
    }
    return self;
}

- (NSString *)dictKey {
    return [NSString stringWithFormat:@"%@%@", FuHttpInfoKey, self.type];
}

@end
