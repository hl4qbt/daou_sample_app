import 'package:flutter_test/flutter_test.dart';
import 'package:daou_sample_app/daou_sample_app.dart';
import 'package:daou_sample_app/daou_sample_app_platform_interface.dart';
import 'package:daou_sample_app/daou_sample_app_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDaouSampleAppPlatform
    with MockPlatformInterfaceMixin
    implements DaouSampleAppPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DaouSampleAppPlatform initialPlatform = DaouSampleAppPlatform.instance;

  test('$MethodChannelDaouSampleApp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDaouSampleApp>());
  });

  test('getPlatformVersion', () async {
    DaouSampleApp daouSampleAppPlugin = DaouSampleApp();
    MockDaouSampleAppPlatform fakePlatform = MockDaouSampleAppPlatform();
    DaouSampleAppPlatform.instance = fakePlatform;

    expect(await daouSampleAppPlugin.getPlatformVersion(), '42');
  });
}
