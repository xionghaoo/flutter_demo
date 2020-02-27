package xh.zero.flutter_demo.plugins

import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import com.amap.api.maps.MapView
import com.google.gson.Gson
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*
import java.util.concurrent.atomic.AtomicInteger
import kotlin.collections.ArrayList
import kotlin.reflect.typeOf

class AmapViewFactory(
        private val lifecycle: Lifecycle?
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    // 视图第一次显示时调用
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val param = Gson().fromJson<AmapParam>(args as? String, AmapParam::class.java)
        val flutterAmapView = FlutterAmapView(context, lifecycle, param)
        flutterAmapView.initialize()
        return flutterAmapView
    }
}