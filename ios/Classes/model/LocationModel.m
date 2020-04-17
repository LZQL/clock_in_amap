//
//  LocationModel.m
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/13.
//

#import "LocationModel.h"

@implementation LocationModel

- (instancetype)initWithLocation:(CLLocation *)location withRegoecode:(AMapLocationReGeocode *)regoecode withError:(NSError *)error{
    self = [super init];
    
    if (self) {
        if (error) {
            self.errorCode = error.code;
            self.errorInfo = error.localizedDescription;
        }else{
            self.latitude = location.coordinate.latitude;
            self.longitude = location.coordinate.longitude;
            
            if(regoecode){
                self.province = regoecode.province;
                self.city = regoecode.city;
                self.district = regoecode.district;
                self.cityCode = regoecode.citycode;
                self.address = regoecode.formattedAddress;
            }
        }
    }
    
    return self;
}



@end
