import 'package:flutter/services.dart';

import 'daou_sample_app_platform_interface.dart';

class DaouSampleApp {
  static const MethodChannel _channel = MethodChannel('daou_sample_app');

  static Future<String?> getPlatformVersion() {
    return DaouSampleAppPlatform.instance.getPlatformVersion();
  }

  /// xcframework 초기화
  static Future<bool> initializeFramework() async {
    try {
      final bool result = await _channel.invokeMethod('initializeFramework');
      return result;
    } on PlatformException catch (e) {
      throw Exception("Failed to initialize framework: ${e.message}");
    }
  }

  /// SimpleTest 함수 호출
  static Future<String?> callSimpleTest() {
    return DaouSampleAppPlatform.instance.callSimpleTest();
  }
}
