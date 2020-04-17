//
//  InitPlugin.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/11.
//

#import "InitPlugin.h"

#import "AMapFoundationKit/AMapFoundationKit.h"


@implementation InitPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {

    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"cim/init"
            binaryMessenger:[registrar messenger]];
    InitPlugin* instance = [[InitPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    if ([@"setKey" isEqualToString:call.method]) {
      NSString *key = call.arguments;
      [AMapServices sharedServices].enableHTTPS = YES;
      // 配置高德地图的key
      [AMapServices sharedServices].apiKey = key;
      result(@YES);
    } else if([@"initTest" isEqualToString:call.method]){
//        NSString *key = call.arguments;
//        NSString *str2 = [[NSString alloc] initWithFormat:@"fuck you  test :  %@",key];

//        result(str2);
        result(@"fuck you  initTest");
    } else {
      result(FlutterMethodNotImplemented);
    }
}

@end
