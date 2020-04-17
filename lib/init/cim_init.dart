

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CIMInit{

  static const MethodChannel _channel_init = const MethodChannel('cim/init');

  // 设置 IOS 的key
  static Future<bool> setApiKey(String key) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _channel_init.invokeMethod('setKey', key);
    } else {
      return Future.value(true);
    }
  }

  static Future<String> testInit(String key) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _channel_init.invokeMethod('initTest', key);
    } else {
      return 'android test';
    }
  }



}