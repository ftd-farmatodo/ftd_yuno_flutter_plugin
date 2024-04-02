import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_flutter_plugin/yuno_flutter_plugin.dart';
import 'package:yuno_flutter_plugin/yuno_flutter_plugin_method_channel.dart';
import 'package:yuno_flutter_plugin/yuno_flutter_plugin_platform_interface.dart';

class MockYunoFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements YunoFlutterPluginPlatform {
  @override
  Future<void> result(
          String publicKey, String checkoutSession, String countryCode) =>
      Future.value(null);

  @override
  Future<String> start(String publicKey, String checkout, String country) =>
      Future.value('');
}

void main() {
  final YunoFlutterPluginPlatform initialPlatform =
      YunoFlutterPluginPlatform.instance;

  test('$MethodChannelYunoFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelYunoFlutterPlugin>());
  });

  test('getYunoStart', () async {
    YunoFlutterPlugin yunoFlutterPlugin = YunoFlutterPlugin();
    MockYunoFlutterPluginPlatform fakePlatform =
        MockYunoFlutterPluginPlatform();
    YunoFlutterPluginPlatform.instance = fakePlatform;

    expect(await yunoFlutterPlugin.start('', '', ''), '');
  });
  test('getYunoResult', () async {
    YunoFlutterPlugin yunoFlutterPlugin = YunoFlutterPlugin();
    MockYunoFlutterPluginPlatform fakePlatform =
        MockYunoFlutterPluginPlatform();
    YunoFlutterPluginPlatform.instance = fakePlatform;

    expect(yunoFlutterPlugin.result('', '', ''), null);
  });
}
