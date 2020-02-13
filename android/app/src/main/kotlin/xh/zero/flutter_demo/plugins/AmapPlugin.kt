package xh.zero.flutter_demo.plugins

import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicInteger

class AmapPlugin : FlutterPlugin, ActivityAware, DefaultLifecycleObserver {

    private var lifecycle: Lifecycle? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private val state = AtomicInteger(0)

    companion object {
        const val CREATED = 1
        const val STARTED = 2
        const val RESUMED = 3
        const val PAUSED = 4
        const val STOPPED = 5
        const val DESTROYED = 6

        const val VIEW_TYPE_ID = "xh.zero/amap"

        fun registerWith(registrar: PluginRegistry.Registrar) {
            if (registrar.activity() == null) return
            val plugin = AmapPlugin()
            registrar.platformViewRegistry()
                    .registerViewFactory(VIEW_TYPE_ID, AmapViewFactory(plugin.state))
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
        lifecycle?.addObserver(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        lifecycle?.addObserver(this)
        pluginBinding?.platformViewRegistry
                ?.registerViewFactory(VIEW_TYPE_ID, AmapViewFactory(state))

    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    // DefaultLifecycleObserver
    override fun onCreate(owner: LifecycleOwner) {
        state.set(CREATED)
    }

    override fun onResume(owner: LifecycleOwner) {
        state.set(RESUMED)
    }

    override fun onPause(owner: LifecycleOwner) {
        state.set(PAUSED)
    }

    override fun onStart(owner: LifecycleOwner) {
        state.set(STARTED)
    }

    override fun onStop(owner: LifecycleOwner) {
        state.set(STOPPED)
    }

    override fun onDestroy(owner: LifecycleOwner) {
        state.set(DESTROYED)
    }
}