import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daou_sample_app/daou_sample_app_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDaouSampleApp platform = MethodChannelDaouSampleApp();
  const MethodChannel channel = MethodChannel('daou_sample_app');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getPlatformVersion') {
            return '42';
          } else if (methodCall.method == 'callSimpleTest') {
            return 'test result';
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('callSimpleTest', () async {
    expect(await platform.callSimpleTest(), 'test result');
  });
}
