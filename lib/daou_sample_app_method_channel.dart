import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'daou_sample_app_platform_interface.dart';

/// An implementation of [DaouSampleAppPlatform] that uses method channels.
class MethodChannelDaouSampleApp extends DaouSampleAppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('daou_sample_app');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> callSimpleTest() async {
    final result = await methodChannel.invokeMethod<String>('callSimpleTest');
    return result;
  }
}
