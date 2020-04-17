//
//  ClockInMap.h
//  clock_in_amap
//
//  Created by 李樟清 on 2020/4/14.
//

#import <Foundation/Foundation.h>


#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClockInMapView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
                viewIdentifier:(int64_t)viewId
                arguments:(id _Nullable)args
                registrar:(NSObject<FlutterPluginRegistrar>*) registrar;

@end

NS_ASSUME_NONNULL_END
