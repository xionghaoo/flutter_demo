package xh.zero.flutter_demo

import android.content.Context
import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class BuildConfigPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private var applicationContext: Context? = null

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

    fun onAttachedToEngine(_applicationContext: Context, messenger: BinaryMessenger) {
        applicationContext = _applicationContext
        methodChannel = MethodChannel(messenger, "xh.zero/version")
        methodChannel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getApplicationVersion") {
            result.success(BuildConfig.VERSION_NAME)

            // notify flutter
            methodChannel?.invokeMethod("callFlutter", null, object : MethodChannel.Result {
                override fun notImplemented() {

                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {

                }

                override fun success(result: Any?) {
                    if (result is String) {
                        Toast.makeText(applicationContext, "received ${result}", Toast.LENGTH_SHORT).show()
                    }
                }
            })

        } else {
            result.notImplemented()
        }
    }
}