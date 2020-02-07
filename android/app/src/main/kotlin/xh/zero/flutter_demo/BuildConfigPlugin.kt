package xh.zero.flutter_demo

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class BuildConfigPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val instance = BuildConfigPlugin()
            instance.onAttachedToEngine(registrar.context(), registrar.messenger());
        }
    }

    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, "xh.zero/version")
        methodChannel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getApplicationVersion") {
            result.success(BuildConfig.VERSION_NAME)
        } else {
            result.notImplemented()
        }
    }
}