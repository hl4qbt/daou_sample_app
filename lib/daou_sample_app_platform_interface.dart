import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'daou_sample_app_method_channel.dart';

abstract class DaouSampleAppPlatform extends PlatformInterface {
  /// Constructs a DaouSampleAppPlatform.
  DaouSampleAppPlatform() : super(token: _token);

  static final Object _token = Object();

  static DaouSampleAppPlatform _instance = MethodChannelDaouSampleApp();

  /// The default instance of [DaouSampleAppPlatform] to use.
  ///
  /// Defaults to [MethodChannelDaouSampleApp].
  static DaouSampleAppPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DaouSampleAppPlatform] when
  /// they register themselves.
  static set instance(DaouSampleAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> callSimpleTest() {
    throw UnimplementedError('callSimpleTest() has not been implemented.');
  }
}
