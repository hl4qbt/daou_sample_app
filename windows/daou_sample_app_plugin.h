#ifndef FLUTTER_PLUGIN_DAOU_SAMPLE_APP_PLUGIN_H_
#define FLUTTER_PLUGIN_DAOU_SAMPLE_APP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace daou_sample_app {

class DaouSampleAppPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DaouSampleAppPlugin();

  virtual ~DaouSampleAppPlugin();

  // Disallow copy and assign.
  DaouSampleAppPlugin(const DaouSampleAppPlugin&) = delete;
  DaouSampleAppPlugin& operator=(const DaouSampleAppPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace daou_sample_app

#endif  // FLUTTER_PLUGIN_DAOU_SAMPLE_APP_PLUGIN_H_
