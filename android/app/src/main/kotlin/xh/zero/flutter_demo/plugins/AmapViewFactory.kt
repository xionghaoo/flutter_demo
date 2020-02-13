package xh.zero.flutter_demo.plugins

import android.content.Context
import com.amap.api.maps.MapView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.atomic.AtomicInteger

class AmapViewFactory(private val state: AtomicInteger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val flutterAmapView = FlutterAmapView(context, state)
        flutterAmapView.initialize()
        return flutterAmapView
    }
}