import 'package:flutter/services.dart';

import 'package:clock_in_amap/map/cim_map.dart';
import 'package:clock_in_amap/model/latlng.dart';
import 'package:flutter/foundation.dart';
class CIMUtil {

  static const MethodChannel _cimUtilsChannel =
      const MethodChannel('cim/util');


  // 计算两点之间的距离
  static Future<double> calculateLineDistance(LatLng latLng1, LatLng latLng2) async{

    Map<String, dynamic> params = {
      "p1": latLng1.toJson(),
      "p2": latLng2.toJson(),
    };

    double length ;

    if (defaultTargetPlatform == TargetPlatform.android) {
      length = await _cimUtilsChannel.invokeMethod('util#calculateLineDistance',params);
    }  else if (defaultTargetPlatform == TargetPlatform.iOS) {
      String tempLength = await _cimUtilsChannel.invokeMethod('util#calculateLineDistance',params);
      length = double.parse(tempLength);
    }


    return length;
  }

}
