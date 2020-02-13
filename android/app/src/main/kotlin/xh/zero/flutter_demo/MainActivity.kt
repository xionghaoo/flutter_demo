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

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import xh.zero.flutter_demo.plugins.AmapPlugin
import xh.zero.flutter_demo.plugins.TextViewPlugin

class MainActivity: FlutterActivity() {
  companion object {
    private const val CHANNEL = "xh.zero/battery"
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    SystemUtils.statusBarTransparent(window)

    GeneratedPluginRegistrant.registerWith(this)
    BuildConfigPlugin.registerWith(registrarFor("xh.zero.flutter_demo.BuildConfigPlugin"))
    TextViewPlugin.registerWidth(registrarFor("xh.zero.flutter_demo.plugins.TextViewPlugin"))
    AmapPlugin.registerWith(registrarFor("xh.zero.flutter_demo.plugins.AmapPlugin"))

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
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

    MethodChannel(flutterView, "xh.zero/map").setMethodCallHandler { call, result ->
      Log.d("amap_test", "启动高德地图, ${call.method}")

      if (call.method == "startAMapPage") {
//        Log.d("amap_test", "启动高德地图")
        startActivity(Intent(this@MainActivity, TestActivity::class.java))
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
