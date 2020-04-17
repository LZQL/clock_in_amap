//import 'dart:async';
//
//import 'package:flutter/services.dart';
//
//class ClockInAmap {
//  static const MethodChannel _channel =
//      const MethodChannel('clock_in_amap');
//
//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }
//}


export 'init/cim_init.dart';

export 'location/cim_location.dart';

export 'map/cim_map.dart';
export 'map/cim_map_view.dart';

export 'model/location_model.dart';
export 'model/latlng.dart';
export 'model/tip.dart';

export 'search/cim_search.dart';

export 'util/cim_util.dart';


