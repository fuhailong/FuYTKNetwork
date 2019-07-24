//
//  NSString+FuAdd.m
//  RAC+MVVM
//
//  Created by mmz on 2019/7/19.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "NSString+FuAdd.h"

@implementation NSString (FuAdd)

///判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)str {
    if (str == nil || str == Nil || str == NULL) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

///获取.string内对应的字符串
- (NSString *)localString {
    return NSLocalizedString(self, nil);
}

///获取App版本信息
+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

///获取App名字
+ (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

///获取设备系统版本号
+ (NSString *)deviceVersion {
    return [[UIDevice currentDevice] systemVersion];
}

@end
