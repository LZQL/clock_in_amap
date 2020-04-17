package com.zeking.clock_in_amap;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.zeking.clock_in_amap.location.LocationPlugin;
import com.zeking.clock_in_amap.map.ClockInMapFactory;
import com.zeking.clock_in_amap.search.SearchPlugin;
import com.zeking.clock_in_amap.util.UtilPlugin;

//public class ClockInAmapPlugin  implements FlutterPlugin{
//  /**
//   * Plugin registration.
//   */
//  public static void registerWith(Registrar registrar) {
//
////        registrar.addRequestPermissionsResultListener();
//
//    // 添加权限回调监听
////        final ClockInMapDelegate delegate = new ClockInMapDelegate(registrar.activity());
////        registrar.addRequestPermissionsResultListener(delegate);
//
//    // 地图 view
//    registrar.platformViewRegistry().registerViewFactory("cim/mapview",
//            new ClockInMapFactory(registrar));
//
//    // 定位
//    final MethodChannel location_channel = new MethodChannel(registrar.messenger(), "cim/location");
//    location_channel.setMethodCallHandler(new LocationPlugin(registrar));
//
//    // util ： 计算两者之间的距离
//    final MethodChannel util_channel = new MethodChannel(registrar.messenger(), "cim/util");
//    util_channel.setMethodCallHandler(new UtilPlugin());
//
//    // 搜索
//    final MethodChannel search_channel = new MethodChannel(registrar.messenger(), "cim/search");
//    search_channel.setMethodCallHandler(new SearchPlugin(registrar));
//
//  }
//
//}

/** ClockInAmapPlugin */
public class ClockInAmapPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "clock_in_amap");
//    channel.setMethodCallHandler(new ClockInAmapPlugin());


    // 地图 view
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("cim/mapview",
            new ClockInMapFactory(flutterPluginBinding));

    // 定位
    final MethodChannel location_channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cim/location");
    location_channel.setMethodCallHandler(new LocationPlugin(flutterPluginBinding));

    // util ： 计算两者之间的距离
    final MethodChannel util_channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cim/util");
    util_channel.setMethodCallHandler(new UtilPlugin());

    // 搜索
    final MethodChannel search_channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cim/search");
    search_channel.setMethodCallHandler(new SearchPlugin(flutterPluginBinding));

  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "clock_in_amap");
    channel.setMethodCallHandler(new ClockInAmapPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
