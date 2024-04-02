import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'yuno_flutter_plugin_platform_interface.dart';

/// An implementation of [YunoFlutterPluginPlatform] that uses method channels.
class MethodChannelYunoFlutterPlugin extends YunoFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yuno');
  //final String publicKey = config.country.secrets.yunoPublicKey;
  //final platform = const MethodChannel('yuno');

  @override
  Future<String> start(
      String publicKey, String checkoutSession, String countryCode) async {
    var params = <String, dynamic>{
      "key": publicKey,
      "checkoutSession": checkoutSession,
      "country": countryCode,
      "action": "start"
    };
    String result = await methodChannel.invokeMethod('init', params);
    return result;
  }

  @override
  Future<void> result(
      String publicKey, String checkoutSession, String countryCode) async {
    var params = <String, dynamic>{
      "key": publicKey,
      "checkoutSession": checkoutSession,
      "country": countryCode,
      "action": "result"
    };
    await methodChannel.invokeMethod('init', params);
  }
}
