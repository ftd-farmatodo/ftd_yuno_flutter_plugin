#import "YunoFlutterPlugin.h"
#if __has_include(<yuno_flutter_plugin/yuno_flutter_plugin-Swift.h>)
#import <yuno_flutter_plugin/yuno_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yuno_flutter_plugin-Swift.h"
#endif

@implementation YunoFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYunoFlutterPlugin registerWithRegistrar:registrar];
}
@end
