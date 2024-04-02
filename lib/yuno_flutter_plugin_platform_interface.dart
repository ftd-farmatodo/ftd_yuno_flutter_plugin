import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'yuno_flutter_plugin_method_channel.dart';

abstract class YunoFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a YunoFlutterPluginPlatform.
  YunoFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoFlutterPluginPlatform _instance = MethodChannelYunoFlutterPlugin();

  /// The default instance of [YunoFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelYunoFlutterPlugin].
  static YunoFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(YunoFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> start(
      String publicKey, String checkoutSession, String countryCode) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> result(
      String publicKey, String checkoutSession, String countryCode) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
