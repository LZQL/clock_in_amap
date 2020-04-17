#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clock_in_amap.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'clock_in_amap'
  s.version          = '0.0.1'
  s.summary          = 'Flutter高德地图打卡功能插件'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/LZQL/clock_in_amap'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Zeking' => '396298154@qq.com' }
  s.source           = { :path => '.' }
  s.resource = 'Assets/*.png'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AMap2DMap'
  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'
  s.dependency 'MJExtension'

  s.static_framework = true
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
