//
//  LocationModel.h
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/13.
//

#import <Foundation/Foundation.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface LocationModel : NSObject

- (instancetype)initWithLocation:(CLLocation *)location withRegoecode:(AMapLocationReGeocode *)regoecode withError:(NSError *)error;

@property(nonatomic) double latitude;       // 维度
@property(nonatomic) double longitude;      // 经度

@property(nonatomic) NSString *province;    // 省
@property(nonatomic) NSString *city;        // 城市
@property(nonatomic) NSString *district;    // 区
@property(nonatomic) NSString *cityCode;
@property(nonatomic) NSString *address;

@property(nonatomic) NSInteger errorCode;
@property(nonatomic) NSString *errorInfo;
@end

//NS_ASSUME_NONNULL_END
