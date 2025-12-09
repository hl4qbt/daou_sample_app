import Flutter
import UIKit
import SampleFramework

public class DaouSampleAppPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "daou_sample_app", binaryMessenger: registrar.messenger())
    let instance = DaouSampleAppPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "callSimpleTest":
        let returnValue = simpleTest()
        result(returnValue)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
