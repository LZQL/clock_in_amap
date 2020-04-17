//
//  ClockInMap.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/14.
//

#import "ClockInMapView.h"

#import <Flutter/Flutter.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "LocationModel.h"

#import "MJExtension.h"

@interface ClockInMapView()<AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>

@property (strong, nonatomic) AMapLocationManager *locationManager;

@end

@implementation ClockInMapView

//{
//
//    MAMapView* _mapView;
//    CGRect _frame;
//    int64_t _viewId;
//    id _args;
//    MAMapView* _mapView;
//
//
//}

static MAMapView* _mapView;
static double tempCentPointLatitude;
static double tempCentPointLongitude;

static double clockInLatitude;
static double clockInLongitude;

static FlutterMethodChannel* methodChannel ;

static AMapSearchAPI* search;

static MAPointAnnotation *annotation;

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args registrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    self = [super init];
    if (self) {
        
        methodChannel = [FlutterMethodChannel methodChannelWithName:@"cim/map_center" binaryMessenger:registrar.messenger];
        
        [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [self onMethodCall:call result:result];
        }];
    
        _mapView = [[MAMapView alloc] initWithFrame:frame];
        _mapView.delegate = self;
        
        @try {
            if(args[@"clockInLatitude"] != NULL ){
                clockInLatitude = [args[@"clockInLatitude"] doubleValue] ;
            }
            
            if([args[@"clockInLongitude"] boolValue] == YES){
                clockInLongitude = [args[@"clockInLongitude"] doubleValue] ;
            }
        } @catch (NSException *exception) {
            
        } @finally {
        }
        
        if(clockInLatitude!=0 && clockInLongitude!=0){
            [self drawClockInPointWithLatitude:clockInLatitude andLongitude:clockInLongitude];
        }
        
        [self setup];
    }

    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"map#moveCamera" isEqualToString:call.method]) {                      // 将地图移动到指定的点
        
       NSDictionary* point = [call arguments][@"point"];
        
       CLLocationCoordinate2D center;
       center.latitude = [point[@"latitude"] doubleValue];
       center.longitude = [point[@"longitude"] doubleValue];

       [_mapView setZoomLevel:17 animated: YES];
       [_mapView setCenterCoordinate:center animated:YES];
        
    } else if([@"map#getMyLocation" isEqualToString:call.method]){          // 我的位置

       CLLocationCoordinate2D center;
       center.latitude = tempCentPointLatitude;
       center.longitude = tempCentPointLongitude;

        [_mapView setZoomLevel:17 animated: YES];
        [_mapView setCenterCoordinate:center animated:YES];
        
        [self.locationManager startUpdatingLocation];
               
    } else if ([@"map#drawClockInPoint" isEqualToString:call.method]) {     // 绘制 选择的 打卡地点
        
        NSDictionary* tempJson = call.arguments[@"point"];
        NSString* lat = tempJson[@"latitude"];
        NSString* lon = tempJson[@"longitude"];
        
        [self drawClockInPointWithLatitude:[lat doubleValue] andLongitude:[lon doubleValue]];
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (nonnull UIView *)view {
    return _mapView;
}

// 初始化地图
- (void)setup{
    // 显示定位蓝点
    _mapView.maxZoomLevel = 19;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;

    // 初始化定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    /// 开始定位
    [self.locationManager startUpdatingLocation];
    
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
}


// 接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    tempCentPointLatitude = location.coordinate.latitude;
    tempCentPointLongitude = location.coordinate.longitude;
    
    CLLocationCoordinate2D center;
    center.latitude = tempCentPointLatitude;
    center.longitude = tempCentPointLongitude;
    
    [_mapView setZoomLevel:17 animated: YES];
    [_mapView setCenterCoordinate:center animated:YES];
    [self.locationManager stopUpdatingLocation];
}


/**
* @brief 地图将要发生移动时调用此接口
* @param mapView 地图view
* @param wasUserAction 标识是否是用户动作
*/
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{

    LocationModel* locationModel = [[LocationModel alloc] init] ;
  
    NSString* json = [locationModel mj_JSONString];
  
    NSDictionary* arguments = @{
        @"centerPointJson" : json
    };
  
    [methodChannel invokeMethod:@"map#getCenterPoint" arguments:arguments];
    
}


/**
* @brief 地图区域改变完成后会调用此接口
* @param mapView 地图View
* @param animated 是否动画
*/
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
   
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    regeo.requireExtension            = YES;
   
    [search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        LocationModel* locationModel = [[LocationModel alloc] init] ;
        
        locationModel.province = response.regeocode.addressComponent.province;
        locationModel.city = response.regeocode.addressComponent.city;
        locationModel.district = response.regeocode.addressComponent.district;
        locationModel.cityCode = response.regeocode.addressComponent.citycode;
        locationModel.address = response.regeocode.formattedAddress;

        locationModel.latitude = request.location.latitude;
        locationModel.longitude = request.location.longitude;
        
        NSString* json = [locationModel mj_JSONString];
        
        NSDictionary* arguments = @{
            @"centerPointJson" : json
        };
        
        [methodChannel invokeMethod:@"map#getCenterPoint" arguments:arguments];
    }
}


-(void)drawClockInPointWithLatitude:(double)latitude andLongitude:(double)longitude{
    
    if (annotation) {
        [_mapView removeAnnotation:annotation];
    }

    CLLocationCoordinate2D point ;
    point.latitude = latitude;
    point.longitude = longitude;
    
    annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = point;
    
    
    [_mapView addAnnotation:annotation];
    
}

/**
* @brief 根据anntation生成对应的View
* @param mapView 地图View
* @param annotation 指定的标注
* @return 生成的标注View
*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
            }
            UIImage *image = [UIImage imageNamed:@"project_img_tag_position"];
            
            CGSize mCGSize ;
            mCGSize.width = 20.8;
            mCGSize.height = 26;
            
            UIGraphicsBeginImageContext(mCGSize);
            [image drawInRect:CGRectMake(0, 0, mCGSize.width, mCGSize.height)];
            UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = scaledImage;
            
            annotationView.centerOffset = CGPointMake(0, -13);
            return annotationView;
        }

    return nil;
}

@end
