//
//  GBDeviceInfo_iOS+iPhoneSimulator.m
//  WingOnTavel
//
//  Created by 钱洋彪 on 2019/9/25.
//  Copyright © 2019 wingontravel.com. All rights reserved.
//

#import "GBDeviceInfo_iOS+iPhoneSimulator.h"

#import <objc/runtime.h>
#import <sys/utsname.h>
#import "dlfcn.h"

#import "GBDeviceInfo_Common.h"
#import "GBDeviceInfo_Subclass.h"

@implementation GBDeviceInfo (iPhoneSimulator)

#if TARGET_IPHONE_SIMULATOR
+ (NSString *)_rawSystemInfoString {
    // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
    return [[[NSProcessInfo new] environment] valueForKey:@"SIMULATOR_MODEL_IDENTIFIER"];
}

+ (GBDeviceVersion)_deviceVersion {
    NSString *systemInfoString = [self _rawSystemInfoString];
    
    NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
    NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
    
    NSUInteger major = 0;
    NSUInteger minor = 0;
    
    if (positionOfComma != NSNotFound) {
        major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
        minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
    }
    
    return GBDeviceVersionMake(major, minor);
}

+ (NSArray *)_modelNuances {
    GBDeviceFamily family = GBDeviceFamilyUnknown;
    GBDeviceModel model = GBDeviceModelUnknown;
    NSString *modelString = @"Unknown Device";
    GBDeviceDisplay display = GBDeviceDisplayUnknown;
    CGFloat pixelsPerInch = 0;
    
    GBDeviceVersion deviceVersion = [self _deviceVersion];
    NSString *systemInfoString = [self _rawSystemInfoString];
    
    
    NSDictionary *familyManifest = @{
        @"iPhone": @(GBDeviceFamilyiPhone),
        @"iPad": @(GBDeviceFamilyiPad),
        @"iPod": @(GBDeviceFamilyiPod),
    };
    
    NSDictionary *modelManifest = @{
        @"iPhone": @{
            // 1st Gen
            @[@1, @1]: @[@(GBDeviceModeliPhone1), @"iPhone 1", @(GBDeviceDisplay3p5Inch), @163],

            // 3G
            @[@1, @2]: @[@(GBDeviceModeliPhone3G), @"iPhone 3G", @(GBDeviceDisplay3p5Inch), @163],

            // 3GS
            @[@2, @1]: @[@(GBDeviceModeliPhone3GS), @"iPhone 3GS", @(GBDeviceDisplay3p5Inch), @163],

            // 4
            @[@3, @1]: @[@(GBDeviceModeliPhone4), @"iPhone 4", @(GBDeviceDisplay3p5Inch), @326],
            @[@3, @2]: @[@(GBDeviceModeliPhone4), @"iPhone 4", @(GBDeviceDisplay3p5Inch), @326],
            @[@3, @3]: @[@(GBDeviceModeliPhone4), @"iPhone 4", @(GBDeviceDisplay3p5Inch), @326],

            // 4S
            @[@4, @1]: @[@(GBDeviceModeliPhone4S), @"iPhone 4S", @(GBDeviceDisplay3p5Inch), @326],

            // 5
            @[@5, @1]: @[@(GBDeviceModeliPhone5), @"iPhone 5", @(GBDeviceDisplay4Inch), @326],
            @[@5, @2]: @[@(GBDeviceModeliPhone5), @"iPhone 5", @(GBDeviceDisplay4Inch), @326],

            // 5c
            @[@5, @3]: @[@(GBDeviceModeliPhone5c), @"iPhone 5c", @(GBDeviceDisplay4Inch), @326],
            @[@5, @4]: @[@(GBDeviceModeliPhone5c), @"iPhone 5c", @(GBDeviceDisplay4Inch), @326],

            // 5s
            @[@6, @1]: @[@(GBDeviceModeliPhone5s), @"iPhone 5s", @(GBDeviceDisplay4Inch), @326],
            @[@6, @2]: @[@(GBDeviceModeliPhone5s), @"iPhone 5s", @(GBDeviceDisplay4Inch), @326],

            // 6 Plus
            @[@7, @1]: @[@(GBDeviceModeliPhone6Plus), @"iPhone 6 Plus", @(GBDeviceDisplay5p5Inch), @401],

            // 6
            @[@7, @2]: @[@(GBDeviceModeliPhone6), @"iPhone 6", @(GBDeviceDisplay4p7Inch), @326],
            
            // 6s
            @[@8, @1]: @[@(GBDeviceModeliPhone6s), @"iPhone 6s", @(GBDeviceDisplay4p7Inch), @326],
            
            // 6s Plus
            @[@8, @2]: @[@(GBDeviceModeliPhone6sPlus), @"iPhone 6s Plus", @(GBDeviceDisplay5p5Inch), @401],
            
            // SE
            @[@8, @4]: @[@(GBDeviceModeliPhoneSE), @"iPhone SE", @(GBDeviceDisplay4Inch), @326],
            
            // 7
            @[@9, @1]: @[@(GBDeviceModeliPhone7), @"iPhone 7", @(GBDeviceDisplay4p7Inch), @326],
            @[@9, @3]: @[@(GBDeviceModeliPhone7), @"iPhone 7", @(GBDeviceDisplay4p7Inch), @326],
            
            // 7 Plus
            @[@9, @2]: @[@(GBDeviceModeliPhone7Plus), @"iPhone 7 Plus", @(GBDeviceDisplay5p5Inch), @401],
            @[@9, @4]: @[@(GBDeviceModeliPhone7Plus), @"iPhone 7 Plus", @(GBDeviceDisplay5p5Inch), @401],
            
            // 8
            @[@10, @1]: @[@(GBDeviceModeliPhone8), @"iPhone 8", @(GBDeviceDisplay4p7Inch), @326],
            @[@10, @4]: @[@(GBDeviceModeliPhone8), @"iPhone 8", @(GBDeviceDisplay4p7Inch), @326],

            // 8 Plus
            @[@10, @2]: @[@(GBDeviceModeliPhone8Plus), @"iPhone 8 Plus", @(GBDeviceDisplay5p5Inch), @401],
            @[@10, @5]: @[@(GBDeviceModeliPhone8Plus), @"iPhone 8 Plus", @(GBDeviceDisplay5p5Inch), @401],
            
            // X
            @[@10, @3]: @[@(GBDeviceModeliPhoneX), @"iPhone X", @(GBDeviceDisplay5p8Inch), @458],
            @[@10, @6]: @[@(GBDeviceModeliPhoneX), @"iPhone X", @(GBDeviceDisplay5p8Inch), @458],

            // XR
            @[@11, @8]: @[@(GBDeviceModeliPhoneXR), @"iPhone XR", @(GBDeviceDisplay6p1Inch), @326],

            // XS
            @[@11, @2]: @[@(GBDeviceModeliPhoneXS), @"iPhone XS", @(GBDeviceDisplay5p8Inch), @458],

            // XS Max
            @[@11, @4]: @[@(GBDeviceModeliPhoneXSMax), @"iPhone XS Max", @(GBDeviceDisplay6p5Inch), @458],
            @[@11, @6]: @[@(GBDeviceModeliPhoneXSMax), @"iPhone XS Max", @(GBDeviceDisplay6p5Inch), @458],
            
            // 11
            @[@12, @1]: @[@(GBDeviceModeliPhone11), @"iPhone 11", @(GBDeviceDisplay6p1Inch), @326],

            // 11 Pro
            @[@12, @3]: @[@(GBDeviceModeliPhone11Pro), @"iPhone 11 Pro", @(GBDeviceDisplay5p8Inch), @458],

            // 11 Pro Max
            @[@12, @5]: @[@(GBDeviceModeliPhone11ProMax), @"iPhone 11 Pro Max", @(GBDeviceDisplay6p5Inch), @458],
            
            // SE 2
            @[@12, @8]: @[@(GBDeviceModeliPhoneSE2), @"iPhone SE 2", @(GBDeviceDisplay4p7Inch), @326],

            // 12 Mini
            @[@13, @1]: @[@(GBDeviceModeliPhone12Mini), @"iPhone 12 Mini", @(GBDeviceDisplay5p4Inch), @476],
            
            // 12
            @[@13, @2]: @[@(GBDeviceModeliPhone12), @"iPhone 12", @(GBDeviceDisplay6p1Inch), @460],
            
            // 12 Pro
            @[@13, @3]: @[@(GBDeviceModeliPhone12Pro), @"iPhone 12 Pro", @(GBDeviceDisplay6p1Inch), @460],
            
            // 12 Pro Max
            @[@13, @4]: @[@(GBDeviceModeliPhone12ProMax), @"iPhone 12 Pro Max", @(GBDeviceDisplay6p7Inch), @458],
        },
        @"iPad": @{
            // 1
            @[@1, @1]: @[@(GBDeviceModeliPad1), @"iPad 1", @(GBDeviceDisplay9p7Inch), @132],

            // 2
            @[@2, @1]: @[@(GBDeviceModeliPad2), @"iPad 2", @(GBDeviceDisplay9p7Inch), @132],
            @[@2, @2]: @[@(GBDeviceModeliPad2), @"iPad 2", @(GBDeviceDisplay9p7Inch), @132],
            @[@2, @3]: @[@(GBDeviceModeliPad2), @"iPad 2", @(GBDeviceDisplay9p7Inch), @132],
            @[@2, @4]: @[@(GBDeviceModeliPad2), @"iPad 2", @(GBDeviceDisplay9p7Inch), @132],

            // Mini
            @[@2, @5]: @[@(GBDeviceModeliPadMini1), @"iPad Mini 1", @(GBDeviceDisplay7p9Inch), @163],
            @[@2, @6]: @[@(GBDeviceModeliPadMini1), @"iPad Mini 1", @(GBDeviceDisplay7p9Inch), @163],
            @[@2, @7]: @[@(GBDeviceModeliPadMini1), @"iPad Mini 1", @(GBDeviceDisplay7p9Inch), @163],

            // 3
            @[@3, @1]: @[@(GBDeviceModeliPad3), @"iPad 3", @(GBDeviceDisplay9p7Inch), @264],
            @[@3, @2]: @[@(GBDeviceModeliPad3), @"iPad 3", @(GBDeviceDisplay9p7Inch), @264],
            @[@3, @3]: @[@(GBDeviceModeliPad3), @"iPad 3", @(GBDeviceDisplay9p7Inch), @264],

            // 4
            @[@3, @4]: @[@(GBDeviceModeliPad4), @"iPad 4", @(GBDeviceDisplay9p7Inch), @264],
            @[@3, @5]: @[@(GBDeviceModeliPad4), @"iPad 4", @(GBDeviceDisplay9p7Inch), @264],
            @[@3, @6]: @[@(GBDeviceModeliPad4), @"iPad 4", @(GBDeviceDisplay9p7Inch), @264],

            // Air
            @[@4, @1]: @[@(GBDeviceModeliPadAir1), @"iPad Air 1", @(GBDeviceDisplay9p7Inch), @264],
            @[@4, @2]: @[@(GBDeviceModeliPadAir1), @"iPad Air 1", @(GBDeviceDisplay9p7Inch), @264],
            @[@4, @3]: @[@(GBDeviceModeliPadAir1), @"iPad Air 1", @(GBDeviceDisplay9p7Inch), @264],

            // Mini 2
            @[@4, @4]: @[@(GBDeviceModeliPadMini2), @"iPad Mini 2", @(GBDeviceDisplay7p9Inch), @326],
            @[@4, @5]: @[@(GBDeviceModeliPadMini2), @"iPad Mini 2", @(GBDeviceDisplay7p9Inch), @326],
            @[@4, @6]: @[@(GBDeviceModeliPadMini2), @"iPad Mini 2", @(GBDeviceDisplay7p9Inch), @326],

            // Mini 3
            @[@4, @7]: @[@(GBDeviceModeliPadMini3), @"iPad Mini 3", @(GBDeviceDisplay7p9Inch), @326],
            @[@4, @8]: @[@(GBDeviceModeliPadMini3), @"iPad Mini 3", @(GBDeviceDisplay7p9Inch), @326],
            @[@4, @9]: @[@(GBDeviceModeliPadMini3), @"iPad Mini 3", @(GBDeviceDisplay7p9Inch), @326],
            
            // Mini 4
            @[@5, @1]: @[@(GBDeviceModeliPadMini4), @"iPad Mini 4", @(GBDeviceDisplay7p9Inch), @326],
            @[@5, @2]: @[@(GBDeviceModeliPadMini4), @"iPad Mini 4", @(GBDeviceDisplay7p9Inch), @326],

            // Air 2
            @[@5, @3]: @[@(GBDeviceModeliPadAir2), @"iPad Air 2", @(GBDeviceDisplay9p7Inch), @264],
            @[@5, @4]: @[@(GBDeviceModeliPadAir2), @"iPad Air 2", @(GBDeviceDisplay9p7Inch), @264],
            
            // Pro 12.9-inch
            @[@6, @7]: @[@(GBDeviceModeliPadPro12p9Inch), @"iPad Pro 12.9-inch", @(GBDeviceDisplay12p9Inch), @264],
            @[@6, @8]: @[@(GBDeviceModeliPadPro12p9Inch), @"iPad Pro 12.9-inch", @(GBDeviceDisplay12p9Inch), @264],
            
            // Pro 9.7-inch
            @[@6, @3]: @[@(GBDeviceModeliPadPro9p7Inch), @"iPad Pro 9.7-inch", @(GBDeviceDisplay9p7Inch), @264],
            @[@6, @4]: @[@(GBDeviceModeliPadPro9p7Inch), @"iPad Pro 9.7-inch", @(GBDeviceDisplay9p7Inch), @264],
            
            // iPad 5th Gen, 2017
            @[@6, @11]: @[@(GBDeviceModeliPad5), @"iPad 2017", @(GBDeviceDisplay9p7Inch), @264],
            @[@6, @12]: @[@(GBDeviceModeliPad5), @"iPad 2017", @(GBDeviceDisplay9p7Inch), @264],

            // Pro 12.9-inch, 2017
            @[@7, @1]: @[@(GBDeviceModeliPadPro12p9Inch2), @"iPad Pro 12.9-inch 2017", @(GBDeviceDisplay12p9Inch), @264],
            @[@7, @2]: @[@(GBDeviceModeliPadPro12p9Inch2), @"iPad Pro 12.9-inch 2017", @(GBDeviceDisplay12p9Inch), @264],
            
            // Pro 10.5-inch, 2017
            @[@7, @3]: @[@(GBDeviceModeliPadPro10p5Inch), @"iPad Pro 10.5-inch 2017", @(GBDeviceDisplay10p5Inch), @264],
            @[@7, @4]: @[@(GBDeviceModeliPadPro10p5Inch), @"iPad Pro 10.5-inch 2017", @(GBDeviceDisplay10p5Inch), @264],
            
            // iPad 6th Gen, 2018
            @[@7, @5]: @[@(GBDeviceModeliPad6), @"iPad 2018", @(GBDeviceDisplay9p7Inch), @264],
            @[@7, @6]: @[@(GBDeviceModeliPad6), @"iPad 2018", @(GBDeviceDisplay9p7Inch), @264],
            
            // iPad 7th Gen, 2019
            @[@7, @11]: @[@(GBDeviceModeliPad7), @"iPad 2019", @(GBDeviceDisplay10p2Inch), @264],
            @[@7, @12]: @[@(GBDeviceModeliPad7), @"iPad 2019", @(GBDeviceDisplay10p2Inch), @264],

            // iPad Pro 3rd Gen 11-inch, 2018
            @[@8, @1]: @[@(GBDeviceModeliPadPro11p), @"iPad Pro 3rd Gen (11 inch, WiFi)", @(GBDeviceDisplay11pInch), @264],
            @[@8, @3]: @[@(GBDeviceModeliPadPro11p), @"iPad Pro 3rd Gen (11 inch, WiFi+Cellular)", @(GBDeviceDisplay11pInch), @264],

            // iPad Pro 3rd Gen 11-inch 1TB, 2018
            @[@8, @2]: @[@(GBDeviceModeliPadPro11p1TB), @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi)", @(GBDeviceDisplay11pInch), @264],
            @[@8, @4]: @[@(GBDeviceModeliPadPro11p1TB), @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)", @(GBDeviceDisplay11pInch), @264],

            // iPad Pro 3rd Gen 12.9-inch, 2018
            @[@8, @5]: @[@(GBDeviceModeliPadPro12p9Inch3), @"iPad Pro 3rd Gen (12.9 inch, WiFi)", @(GBDeviceDisplay12p9Inch), @264],
            @[@8, @7]: @[@(GBDeviceModeliPadPro12p9Inch3), @"iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)", @(GBDeviceDisplay12p9Inch), @264],

            // iPad Pro 3rd Gen 12.9-inch 1TB, 2018
            @[@8, @6]: @[@(GBDeviceModeliPadPro12p9Inch31TB), @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)", @(GBDeviceDisplay12p9Inch), @264],
            @[@8, @8]: @[@(GBDeviceModeliPadPro12p9Inch31TB), @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)", @(GBDeviceDisplay12p9Inch), @264],
            
            // iPad Pro 4rd Gen 11-inch, 2020
            @[@8, @9]: @[@(GBDeviceModeliPadPro11pInch4), @"iPad Pro 4rd Gen (11 inch, WiFi)", @(GBDeviceDisplay11pInch), @264],
            @[@8, @10]: @[@(GBDeviceModeliPadPro11pInch4), @"iPad Pro 4rd Gen (11 inch, WiFi+Cellular)", @(GBDeviceDisplay11pInch), @264],

            // iPad Pro 4rd Gen 12.9-inch, 2020
            @[@8, @11]: @[@(GBDeviceModeliPadPro12p9Inch4), @"iPad Pro 4rd Gen (12.9 inch, WiFi)", @(GBDeviceDisplay12p9Inch), @264],
            @[@8, @12]: @[@(GBDeviceModeliPadPro12p9Inch4), @"iPad Pro 4rd Gen (12.9 inch, WiFi+Cellular)", @(GBDeviceDisplay12p9Inch), @264],

            // Mini 5
            @[@11, @1]: @[@(GBDeviceModeliPadMini5), @"iPad Mini 5", @(GBDeviceDisplay7p9Inch), @326],
            @[@11, @2]: @[@(GBDeviceModeliPadMini5), @"iPad Mini 5", @(GBDeviceDisplay7p9Inch), @326],
            
            // Air 3
            @[@11, @3]: @[@(GBDeviceModeliPadAir3), @"iPad Air 3", @(GBDeviceDisplay10p5Inch), @264],
            @[@11, @4]: @[@(GBDeviceModeliPadAir3), @"iPad Air 3", @(GBDeviceDisplay10p5Inch), @264],
            
            // iPad 8th Gen, 2020
            @[@11, @6]: @[@(GBDeviceModeliPad8), @"iPad 2020", @(GBDeviceDisplay10p2Inch), @264],
            @[@11, @7]: @[@(GBDeviceModeliPad8), @"iPad 2020", @(GBDeviceDisplay10p2Inch), @264],
            
            // Air 4
            @[@13, @1]: @[@(GBDeviceModeliPadAir4), @"iPad Air 4", @(GBDeviceDisplay10p9Inch), @264],
            @[@13, @2]: @[@(GBDeviceModeliPadAir4), @"iPad Air 4", @(GBDeviceDisplay10p9Inch), @264],
        },
        @"iPod": @{
            // 1st Gen
            @[@1, @1]: @[@(GBDeviceModeliPod1), @"iPod Touch 1", @(GBDeviceDisplay3p5Inch), @163],

            // 2nd Gen
            @[@2, @1]: @[@(GBDeviceModeliPod2), @"iPod Touch 2", @(GBDeviceDisplay3p5Inch), @163],

            // 3rd Gen
            @[@3, @1]: @[@(GBDeviceModeliPod3), @"iPod Touch 3", @(GBDeviceDisplay3p5Inch), @163],

            // 4th Gen
            @[@4, @1]: @[@(GBDeviceModeliPod4), @"iPod Touch 4", @(GBDeviceDisplay3p5Inch), @326],

            // 5th Gen
            @[@5, @1]: @[@(GBDeviceModeliPod5), @"iPod Touch 5", @(GBDeviceDisplay4Inch), @326],

            // 6th Gen
            @[@7, @1]: @[@(GBDeviceModeliPod6), @"iPod Touch 6", @(GBDeviceDisplay4Inch), @326],
            
            // 7th Gen
            @[@9, @1]: @[@(GBDeviceModeliPod7), @"iPod Touch 7", @(GBDeviceDisplay4Inch), @326],
        },
    };
    
    for (NSString *familyString in familyManifest) {
        if ([systemInfoString hasPrefix:familyString]) {
            family = [familyManifest[familyString] integerValue];
            
            NSArray *modelNuances = modelManifest[familyString][@[@(deviceVersion.major), @(deviceVersion.minor)]];
            if (modelNuances) {
                model = [modelNuances[0] integerValue];
                modelString = [modelNuances[1] stringByAppendingString:@" Simulator"];
                display = [modelNuances[2] integerValue];
                pixelsPerInch = [modelNuances[3] doubleValue];
            }
            break;
        }
    }
    
    return @[@(family), @(model), modelString, @(display), @(pixelsPerInch)];
}
#endif

@end
