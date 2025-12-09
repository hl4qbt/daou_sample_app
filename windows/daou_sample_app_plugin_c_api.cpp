#include "include/daou_sample_app/daou_sample_app_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "daou_sample_app_plugin.h"

void DaouSampleAppPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  daou_sample_app::DaouSampleAppPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
