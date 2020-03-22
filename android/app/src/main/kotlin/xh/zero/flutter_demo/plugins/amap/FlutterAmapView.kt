package xh.zero.flutter_demo.plugins.amap

import android.content.Context
import android.util.Log
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.MapView
import com.amap.api.maps.model.*
import com.google.gson.Gson
import io.flutter.plugin.platform.PlatformView
import xh.zero.flutter_demo.R

/**
 * 高德地图，每次打开页面时都会创建新的MapView，
 * 移动地图时调用getView刷新绘制，关闭页面时调用dispose方法
 */
class FlutterAmapView(
        private val context: Context?,
        private val lifecycle: Lifecycle?,
        private val param: AmapParam
) : PlatformView, DefaultLifecycleObserver {

    private var aMap: AMap? = null
    private var mapView: MapView = MapView(context)
    private var myMarker: Marker? = null

    private var actualMap: IActualMap? = null

    init {
        lifecycle?.addObserver(this)
    }

    override fun getView(): View {
        return mapView
    }

    fun initialize() {

    }

    override fun onFlutterViewDetached() {
    }

    override fun dispose() {
        mapView.onDestroy()
    }

    override fun onCreate(owner: LifecycleOwner) {
        mapView.onCreate(null)

        aMap = mapView.map
        if (param.initialCenterPoint != null && param.initialCenterPoint.size == 2) {
            aMap?.moveCamera(
                    CameraUpdateFactory.newLatLngZoom(
                            LatLng(param.initialCenterPoint[0], param.initialCenterPoint[1]), param.initialZoomLevel
                            ?: 17f
                    )
            )
        }

        // 设置点击监听器
//        aMap?.setOnMapClickListener(this)
        // 禁止旋转手势
        aMap?.uiSettings?.isRotateGesturesEnabled = false
        // 禁止倾斜手势
        aMap?.uiSettings?.isTiltGesturesEnabled = false
        // 隐藏缩放按钮
        aMap?.uiSettings?.isZoomControlsEnabled = false
        // 显示比例尺
        aMap?.uiSettings?.isScaleControlsEnabled = true
        // 显示室内地图
        aMap?.showIndoorMap(true)

        // 开启我当前的位置蓝点
        if (param.enableMyLocation) {
            val locationStyle = MyLocationStyle()
            locationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER)
//            locationStyle.strokeColor(resources.getColor(R.color.overlay_map_location))
            locationStyle.strokeWidth(0f)
//            locationStyle.radiusFillColor(resources.getColor(R.color.overlay_map_location))
            locationStyle.interval(5000)
            aMap?.myLocationStyle = locationStyle
            aMap?.isMyLocationEnabled = true

            aMap?.setOnMyLocationChangeListener { location ->

//                myMarker?.position = LatLng(location.latitude, location.longitude)
            }
        }

        // 开启我当前的位置Marker
        if (param.enableMyMarker) {
            // 定位蓝点
//            val myLoc = MapUtil.transformToLatLng(viewModel.getLocation())
            myMarker = aMap?.addMarker(MarkerOptions()
                    .position(LatLng(param.initialCenterPoint!![0], param.initialCenterPoint[1]))
                    .title("我的位置")
                    .infoWindowEnable(false)
                    .icon(BitmapDescriptorFactory.fromResource(R.mipmap.ic_map_driver)))
//            my_location.show()
//            OnceClickStrategy.onceClick(my_location) {
//                relocate()
//            }
        }
        Log.d("FlutterAmapView", "${Gson().toJson(param)}")
        when(param.mapType) {
            AmapParam.ROUTE_MAP ->
                actualMap = RouteMapImpl(context, aMap, param)
            AmapParam.ADDRESS_DESCRIPTION_MAP ->
                actualMap = AddressDescriptionMapImpl(context, aMap, param)
            else -> {}
        }
        actualMap?.onCreate()
    }

    override fun onResume(owner: LifecycleOwner) {
        mapView.onResume()
    }

    override fun onPause(owner: LifecycleOwner) {
        mapView.onPause()
    }


}