//
//  TipModel.h
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/17.
//

#import <Foundation/Foundation.h>

#import "LatLng.h"

NS_ASSUME_NONNULL_BEGIN

@interface TipModel : NSObject

@property(nonatomic,strong) LatLng* latLonPoint;


@property(nonatomic) NSString *name;
@property(nonatomic) NSString *address;
@property(nonatomic) NSString *district;    

@end

NS_ASSUME_NONNULL_END
