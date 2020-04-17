//
//  SearchPlugin.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/17.
//

#import "SearchPlugin.h"

#import <AMapSearchKit/AMapSearchKit.h>

#import "TipModel.h"
#import "LatLng.h"
#import "MJExtension.h"

@interface SearchPlugin()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation SearchPlugin

static FlutterResult mResult;

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"cim/search"
            binaryMessenger:[registrar messenger]];
    SearchPlugin* instance = [[SearchPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    mResult = result;
    if ([@"search#searchAddress" isEqualToString:call.method]) {
        NSString* keyWord = [call arguments][@"keyword"];
        [self searchAddress:keyWord result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)searchAddress:(NSString*)keyWord result:(FlutterResult)result{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = keyWord;
    
    request.cityLimit           = YES;
        
    [self.search AMapPOIKeywordsSearch:request];
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray<TipModel *> * tempList = [NSMutableArray array];;
    
    NSArray<AMapPOI *> *pois = response.pois;
    for (int i = 0; i < pois.count; ++i) {
        AMapPOI* temp = pois[i];
        
        TipModel* tipModel = [[TipModel alloc] init];
        
        tipModel.name  = temp.name;
        
        NSMutableString *str = [NSMutableString string];
        [str appendFormat:@"%@%@%@",temp.province,temp.city,temp.district];
        tipModel.district = str;
        
        tipModel.address = temp.address;
        
        LatLng* latLng = [[LatLng alloc] init];
        latLng.latitude = temp.location.latitude;
        latLng.longitude = temp.location.longitude;
        
        tipModel.latLonPoint = latLng;

        [tempList addObject:tipModel];
    }
    
    NSArray *dictArray = [TipModel mj_keyValuesArrayWithObjectArray:tempList];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    mResult(jsonString);
    
}


@end
