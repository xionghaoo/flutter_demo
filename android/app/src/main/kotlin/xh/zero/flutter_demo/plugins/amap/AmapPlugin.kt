package xh.zero.flutter_demo.plugins.amap

import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicInteger

class AmapPlugin : FlutterPlugin, ActivityAware, DefaultLifecycleObserver {

    private var lifecycle: Lifecycle? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    companion object {
        const val VIEW_TYPE_ID = "xh.zero/amap"

        // v1版本插件的注册方式
        fun registerWith(registrar: PluginRegistry.Registrar) {
            if (registrar.activity() == null) return
            val plugin = AmapPlugin()
            registrar.platformViewRegistry()
                    .registerViewFactory(VIEW_TYPE_ID, AmapViewFactory(null))

        }
    }

    // FlutterPlugin
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = null
    }

    // ActivityAware
    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        pluginBinding?.platformViewRegistry
                ?.registerViewFactory(VIEW_TYPE_ID, AmapViewFactory(lifecycle))

    }

    override fun onDetachedFromActivityForConfigChanges() {

    }
}