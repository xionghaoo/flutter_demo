package xh.zero.flutter_demo.plugins

import android.content.Context
import android.util.Log
import android.view.View
import com.amap.api.maps.MapView
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.FlutterView
import java.util.concurrent.atomic.AtomicInteger

class FlutterAmapView(
        private val context: Context?,
        private val state: AtomicInteger
) : PlatformView {

    private var mapView: MapView = MapView(context)

    init {
        mapView.onCreate(null)
    }

    override fun getView(): View {
//        Log.d("amap_test", "get amap view: ${mapView}")
        return mapView
    }

    fun initialize() {
        when (state.get()) {
            AmapPlugin.CREATED -> mapView.onCreate(null)
            AmapPlugin.PAUSED -> mapView.onPause()
            AmapPlugin.RESUMED -> mapView.onResume()
            AmapPlugin.DESTROYED -> mapView.onDestroy()
        }
        Log.d("amap_test", "amap state: ${state.get()}")
    }

    override fun dispose() {

    }
}