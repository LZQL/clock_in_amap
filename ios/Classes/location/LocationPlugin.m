//
//  LocationPlugin.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/11.
//

#import "LocationPlugin.h"

#import <Flutter/Flutter.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "LocationModel.h"
#import "MJExtension.h"

@interface LocationPlugin()<AMapLocationManagerDelegate,FlutterStreamHandler>

@property (nonatomic, retain) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;


//@property (nonatomic, weak) FlutterMethodChannel* methodChannel;
//
//@property (nonatomic,weak) FlutterEventChannel* eventChanel;
//@property (nonatomic, weak) FlutterEventSink sink;

@end

@implementation LocationPlugin


static FlutterEventSink sink;

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    
    FlutterMethodChannel* locationMethodChannel = [FlutterMethodChannel
      methodChannelWithName:@"cim/location"
            binaryMessenger:[registrar messenger]];
    LocationPlugin* instance = [[LocationPlugin alloc] init];
//    instance.methodChannel = locationMethodChannel;
    [registrar addMethodCallDelegate:instance channel:locationMethodChannel];
    
    FlutterEventChannel* eventChanel = [FlutterEventChannel eventChannelWithName:@"cim/location_event" binaryMessenger:[registrar messenger]];
    [eventChanel setStreamHandler:instance];
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([@"locationTest" isEqualToString:call.method]) {
        result(@"fuck you locationTest");
    } else if([@"location#getLocationOnce" isEqualToString:call.method]){  // 单次定位
        [self getLocationOnce:result];
    } else if ([@"location#getLocations" isEqualToString:call.method]) {   // 连续定位
        [self getLocations];
//        result(@([self stopLocation]));
    } else if ([@"location#stopLocation" isEqualToString:call.method]) {   // 停止定位
        result(@([self stopLocation]));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// 单次定位
-(void) getLocationOnce:(FlutterResult)result{
    
    [self setOption];
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error != nil && error.code == AMapLocationErrorLocateFailed) {
            //定位错误：此时location和regeocode没有返回值
//            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.userInfo);
            return;
        } else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
            
            //存在虚拟定位的风险的定位结果
            __unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
//            NSLog(@"%@", riskyLocateResult);
            //存在外接的辅助定位设备
            __unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
//            NSLog(@"%@", externalAccressory);
            
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作
//            NSLog(@"%@", [NSString stringWithFormat:@"%@", regeocode.formattedAddress]);
//            NSLog(@"%@", [NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
//
//            NSLog(@"%@", [NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]);
//            NSLog(@"%@", [NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]);
            
            NSString *json =[[[LocationModel alloc] initWithLocation:location
                                                       withRegoecode:regeocode
                                                           withError:error] mj_JSONString];
            
//            NSLog(@"最后结果json： %@", json);
            
            sink(json);
        }
        
        }];

}

// 多次定位
- (void)getLocations{
    
    [self setOption];
    
    [self.locationManager startUpdatingLocation];
}

// 配置option
-(void) setOption{
    if(!self.locationManager){
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
    //    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为10s
        self.locationManager.locationTimeout =10;
        //   逆地理请求超时时间，最低2s，此处设置为10s
        self.locationManager.reGeocodeTimeout = 10;
        
        [self.locationManager setLocatingWithReGeocode:YES];
        
        [self.locationManager setDetectRiskOfFakeLocation: YES];
        
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    }
}

//停止定位
-(BOOL)stopLocation{
    if(self.locationManager){
        //停止定位
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
        self.locationManager = nil;
        
        return YES;
    }
    return NO;
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    if (reGeocode == nil)
    {
        return ;
//      NSLog(@"reGeocode:%@", reGeocode);
//      NSLog(@"reGeocode.formattedAddress:%@", reGeocode.formattedAddress);
    }
  
    if(sink){
        
        NSString *json =[[[LocationModel alloc] initWithLocation:location
                                                   withRegoecode:reGeocode
                                                       withError:nil] mj_JSONString];
        
//        NSLog(@"最后结果json： %@", json);
        
        sink(json);
    }
    
               
    
}


- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    sink = events;
    return nil;
}

@end
