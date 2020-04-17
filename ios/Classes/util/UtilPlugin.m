//
//  UtilPlugin.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/17.
//

#import "UtilPlugin.h"

#import "MAGeometry.h"

@implementation UtilPlugin


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"cim/util"
            binaryMessenger:[registrar messenger]];
    UtilPlugin* instance = [[UtilPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    mResult = result;
    if ([@"util#calculateLineDistance" isEqualToString:call.method]) {
//        NSString* keyWord = [call arguments][@"keyword"];
//        [self searchAddress:keyWord result:result];
        
        NSDictionary* p1 = [call arguments][@"p1"];
        NSDictionary* p2 = [call arguments][@"p2"];
        
        [self calculateLineDistance:p1 longitude:p2 result:result];
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)calculateLineDistance:(NSDictionary*)p1 longitude:(NSDictionary*)p2 result:(FlutterResult)result{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([p1[@"latitude"] doubleValue],[p1[@"longitude"] doubleValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([p2[@"latitude"] doubleValue],[p2[@"longitude"] doubleValue]));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    result([NSString stringWithFormat:@"%f",distance]);
}


@end
