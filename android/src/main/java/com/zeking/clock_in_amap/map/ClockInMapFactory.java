package com.zeking.clock_in_amap.map;

import android.content.Context;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

//import com.zeking.clock_in_map.ClockInMapDelegate;


public class ClockInMapFactory extends PlatformViewFactory {

    public FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
//    private final PluginRegistry.Registrar registrar;
//    private final ClockInMapDelegate delegate;

//    public ClockInMapFactory(PluginRegistry.Registrar registrar) {
////    public ClockInMapFactory(PluginRegistry.Registrar registrar, ClockInMapDelegate delegate) {
//        super(StandardMessageCodec.INSTANCE);
//        this.registrar = registrar;
////        this.delegate = delegate;
//    }


    public ClockInMapFactory(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
//    public ClockInMapFactory(PluginRegistry.Registrar registrar, ClockInMapDelegate delegate) {
        super(StandardMessageCodec.INSTANCE);
        this.flutterPluginBinding = flutterPluginBinding;
//        this.delegate = delegate;
    }



    @Override
    public PlatformView create(Context context, int i, Object o) {
        Map<String, Object> params = (Map<String, Object>) o;

        return new ClockInMapView(context, flutterPluginBinding,params);
    }

}
