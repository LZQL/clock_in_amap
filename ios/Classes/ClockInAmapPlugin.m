#import "ClockInAmapPlugin.h"

#import "AMapFoundationKit/AMapFoundationKit.h"
#import "AMapLocationKit.h"

#import "map/ClockInMapViewFactory.h"
#import "init/InitPlugin.h"
#import "location/LocationPlugin.h"
#import "search/SearchPlugin.h"
#import "util/UtilPlugin.h"

@implementation ClockInAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  FlutterMethodChannel* channel = [FlutterMethodChannel
//      methodChannelWithName:@"clock_in_amap"
//            binaryMessenger:[registrar messenger]];
//  ClockInAmapPlugin* instance = [[ClockInAmapPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
    
    
    // 地图 view
    ClockInMapViewFactory* clockInMapFactory = [[ClockInMapViewFactory alloc] initWithRegister:registrar];
    [registrar registerViewFactory:clockInMapFactory withId:@"cim/mapview"];
//    [registrar registerViewFactory:clockInMapFactory withId:@"plugins.weilu/flutter_2d_amap"];
    
    // 初始化
    [InitPlugin registerWithRegistrar:registrar];
    
    // 定位
    [LocationPlugin registerWithRegistrar:registrar];
    
    // 搜索
    [SearchPlugin registerWithRegistrar:registrar];
    
    // util ： 计算两者之间的距离
    [UtilPlugin registerWithRegistrar:registrar];
   
}

//- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
//}

@end
