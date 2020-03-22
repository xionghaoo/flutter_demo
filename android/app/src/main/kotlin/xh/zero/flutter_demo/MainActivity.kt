package xh.zero.flutter_demo

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import com.ks.common.utils.SystemUtils
import com.tekartik.sqflite.SqflitePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.camera.CameraPlugin
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin
import xh.zero.flutter_demo.plugins.amap.AmapPlugin
import xh.zero.flutter_demo.plugins.TextViewPlugin

class MainActivity: FlutterActivity() {

  companion object {
    private const val CHANNEL = "xh.zero/battery"
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    SystemUtils.statusBarTransparent(window)
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    // v2 version plugin register
    flutterEngine.plugins.add(CameraPlugin())
    flutterEngine.plugins.add(PathProviderPlugin())
    flutterEngine.plugins.add(SharedPreferencesPlugin())
    flutterEngine.plugins.add(BuildConfigPlugin())
    flutterEngine.plugins.add(AmapPlugin())

    // v1 version plugin register
    val registry = ShimPluginRegistry(flutterEngine)
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"))
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"))
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"))
    TextViewPlugin.registerWidth(registry.registrarFor("xh.zero.flutter_demo.plugins.TextViewPlugin"))

    MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
      Log.d("amap_test", "getBatteryLevel, ${call.method}")

      when (call.method) {
        "getBatteryLevel" -> {
          val batteryLevel = getBatteryLevel()

          if (batteryLevel != -1) {
            result.success(batteryLevel)
          } else {
            result.error("UNAVAILABLE", "Battery level not available.", null)
          }
        }
        else -> result.notImplemented()
      }
    }

    MethodChannel(flutterEngine.dartExecutor, "xh.zero/map").setMethodCallHandler { call, result ->
      Log.d("amap_test", "启动高德地图, ${call.method}")

      if (call.method == "startAMapPage") {
//        Log.d("amap_test", "启动高德地图")
        startActivity(Intent(this, TestActivity::class.java))
        result.success(null)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }
}
