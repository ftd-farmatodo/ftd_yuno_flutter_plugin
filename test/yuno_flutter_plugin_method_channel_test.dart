import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_flutter_plugin/yuno_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelYunoFlutterPlugin platform = MethodChannelYunoFlutterPlugin();
  const MethodChannel channel = MethodChannel('yuno_flutter_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getYunoStart', () async {
    expect(await platform.start('', '', ''), '');
  });
  test('getYunoResult', () async {
    expect(platform.result('', '', ''), null);
  });
}
