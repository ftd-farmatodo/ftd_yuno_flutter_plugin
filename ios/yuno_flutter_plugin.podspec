#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint yuno_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'yuno_flutter_plugin'
  s.version          = '0.0.2'
  s.summary          = 'Plugin for accessing the yuno sdk'
  s.description      = <<-DESC
Flutter plugin project for Yuno SDK.
                       DESC
  s.homepage         = 'https://docs.y.uno/docs/yuno-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Edbin Fernández' => 'e.fernandez@deepcompany.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'YunoSDK','1.13.0'
  s.static_framework = true
  s.platform = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.resource_bundles = {
      'Resources' => [
          'YunoSDK.xcframework/Assets/**/*.xcassets',
          'YunoSDK.xcframework/Assets/Localization/*.lproj',
          'YunoSDK.xcframework/Assets/**/*.{storyboard,xib,json,ttf}'
      ]
  }
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => ['${PODS_XCFRAMEWORKS_BUILD_DIR}/YunoSDK'] }
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386, arm64', 
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' 
  }
  s.swift_version = '5.4'
end
