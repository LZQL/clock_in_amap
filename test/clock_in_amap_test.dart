import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock_in_amap/clock_in_amap.dart';

void main() {
  const MethodChannel channel = MethodChannel('clock_in_amap');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await ClockInAmap.platformVersion, '42');
  });
}
