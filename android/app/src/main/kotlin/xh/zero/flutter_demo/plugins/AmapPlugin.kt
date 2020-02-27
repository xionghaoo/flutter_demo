package xh.zero.flutter_demo.plugins

import android.app.Activity
import android.app.Application
import android.os.Bundle
import android.util.Log
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
            Log.d("AmapPlugin", "registerWith")

        }
    }

    // FlutterPlugin
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        Log.d("AmapPlugin", "onAttachedToEngine")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = null
        Log.d("AmapPlugin", "onDetachedFromEngine")
    }

    // ActivityAware
    override fun onDetachedFromActivity() {
        Log.d("AmapPlugin", "onDetachedFromActivity")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        lifecycle?.addObserver(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("AmapPlugin", "onAttachedToActivity")

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
        Log.d("AmapPlugin", "onCreate")

    }

    override fun onResume(owner: LifecycleOwner) {
        state.set(RESUMED)
        Log.d("AmapPlugin", "onResume")

    }

    override fun onPause(owner: LifecycleOwner) {
        state.set(PAUSED)
        Log.d("AmapPlugin", "onPause")

    }

    override fun onStart(owner: LifecycleOwner) {
        state.set(STARTED)
        Log.d("AmapPlugin", "onStart")

    }

    override fun onStop(owner: LifecycleOwner) {
        state.set(STOPPED)
        Log.d("AmapPlugin", "onStop")

    }

    override fun onDestroy(owner: LifecycleOwner) {
        state.set(DESTROYED)
        Log.d("AmapPlugin", "onDestroy")

    }
}