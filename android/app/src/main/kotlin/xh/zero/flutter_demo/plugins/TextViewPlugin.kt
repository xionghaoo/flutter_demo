package xh.zero.flutter_demo.plugins

import io.flutter.plugin.common.PluginRegistry
import xh.zero.flutter_demo.plugins.TextViewFactory

class TextViewPlugin {
    companion object {
        fun registerWidth(registrar: PluginRegistry.Registrar) {
            registrar.platformViewRegistry()
                    .registerViewFactory("xh.zero/textview", TextViewFactory(registrar.messenger()))
        }
    }
}