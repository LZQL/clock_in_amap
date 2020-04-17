//
//  ClockInMapFactory.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/14.
//

#import "ClockInMapViewFactory.h"

#import <MAMapKit/MAMapKit.h>

#import "ClockInMapView.h"

@implementation ClockInMapViewFactory{
    NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithRegister:(NSObject<FlutterPluginRegistrar> *)registrar{
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (NSObject <FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{

    ClockInMapView* clockInMapView = [[ClockInMapView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args registrar:_registrar];
    return clockInMapView;
}

@end
