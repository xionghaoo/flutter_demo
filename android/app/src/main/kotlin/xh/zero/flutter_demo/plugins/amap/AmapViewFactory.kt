package xh.zero.flutter_demo.plugins.amap

import android.content.Context
import androidx.lifecycle.Lifecycle
import com.google.gson.Gson
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

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