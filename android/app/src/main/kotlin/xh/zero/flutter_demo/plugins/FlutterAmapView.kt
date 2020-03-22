package xh.zero.flutter_demo.plugins

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
import com.amap.api.services.core.AMapException
import com.amap.api.services.route.*
import com.google.gson.Gson
import com.ks.amap.AMapUtil
import com.ks.amap.DrivingRouteOverlay
import com.ks.amap.RideRouteOverlay
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.FlutterView
import xh.zero.flutter_demo.R
import java.util.concurrent.atomic.AtomicInteger

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

    private val rideRouteOverlayList = ArrayList<RideRouteOverlay>()
    private val driverRouteOverlayList = ArrayList<DrivingRouteOverlay>()

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
        drawRoutePaths()
    }

    override fun onResume(owner: LifecycleOwner) {
        mapView.onResume()
    }

    override fun onPause(owner: LifecycleOwner) {
        mapView.onPause()
    }

    private fun drawRoutePaths() {
        val startAddrList = param.startAddressList
        val endAddrList = param.endAddressList
        if (startAddrList == null
                || endAddrList == null
                || startAddrList.size != endAddrList.size
                || startAddrList.size == 0 || endAddrList.size == 0
        ) {
//            CommonUtils.showToast(context, "地址信息不完整")
            return
        }

        rideRouteOverlayList.clear()
        driverRouteOverlayList.clear()

        startAddrList.mapIndexed { index, startAddr ->
            val endAddr = endAddrList[index]
//            if (configuration?.lineType == LineType.ROUTE) {
//                if (startAddr.routeType == AddressInfo.ROUTE_DRIVE) {
//                    driveRoute(startAddr, endAddr)
//                } else {
//                    rideRoute(startAddr, endAddr)
//                }
//            } else {
//                drawOrderLines(index, startAddr, endAddr)
//            }
            driveRoute(startAddr, endAddr)
        }

    }

    private fun driveRoute(startAddr: AmapParam.AddressInfo, endAddr: AmapParam.AddressInfo) {
        val routeSearch = RouteSearch(context)
        routeSearch.setRouteSearchListener(MapRouteSearchListener(
                context = context,
                aMap = aMap,
                startAddr = startAddr,
                endAddr = endAddr,
                rideOverlayList = rideRouteOverlayList,
                driverOverlayList = driverRouteOverlayList
        ))

        val fromAndTo = RouteSearch.FromAndTo(
                MapUtil.convertGeoPointToLatLonPoint(startAddr.geo),
                MapUtil.convertGeoPointToLatLonPoint(endAddr.geo)
        )
        fromAndTo.plateProvince = "粤"
        fromAndTo.plateNumber = "B6BN05"
        // RouteSearch.DRIVING_SINGLE_DEFAULT 驾车
        // RouteSearch.RIDING_DEFAULT 骑行 时间最少
        // DRIVING_PURE_ELECTRIC_VEHICLE 纯电动车(小汽车)
        // DRIVEING_PLAN_FASTEST_SHORTEST 不考虑路况，返回速度最优、耗时最短的路
        // 文档
        // http://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/index.html?com/amap/api/services/route/RouteSearch.RideRouteQuery.html
        // DRIVING_SINGLE_SHORTEST: 最短距离
        val query = RouteSearch.DriveRouteQuery(fromAndTo, RouteSearch.DRIVING_SINGLE_SHORTEST, null, null, "")
        routeSearch.calculateDriveRouteAsyn(query)
    }

    internal class MapRouteSearchListener(
            private val context: Context?,
            private val aMap: AMap?,
            private val startAddr: AmapParam.AddressInfo,
            private val endAddr: AmapParam.AddressInfo,
            private val rideOverlayList: ArrayList<RideRouteOverlay>,
            private val driverOverlayList: ArrayList<DrivingRouteOverlay>
    ) : RouteSearch.OnRouteSearchListener {
        override fun onDriveRouteSearched(result: DriveRouteResult?, errorCode: Int) {
            // 驾车路线查询
            if (errorCode == AMapException.CODE_AMAP_SUCCESS && result?.paths != null && result.paths.size > 0) {
                val drivePath: DrivePath = result.paths[0] ?: return

                val overlay = DrivingRouteOverlay(
                        context,
                        aMap,
                        drivePath,
                        result.startPos,
                        result.targetPos,
                        null,
                        null,
                        null
                )
                driverOverlayList.add(overlay)
                overlay.setNodeIconVisibility(true)//设置节点marker是否显示
                overlay.setIsColorfulline(true)//是否用颜色展示交通拥堵情况，默认true
                overlay.removeFromMap()
                overlay.addToMap(startAddr.address, endAddr.address)

                // 路径缩放级别，值越小，信息越详细
                overlay.zoomToSpan(context?.resources?.getDimension(R.dimen.map_zoom_edge_width)?.toInt() ?: 300)

                // 距离 米
                val dis = drivePath.distance.toInt()
                // 时间 秒
                val dur = drivePath.duration.toInt()
                val friendlyDistance = AMapUtil.getFriendlyLength(dis)
                val friendlyTime = AMapUtil.getFriendlyTime(dur)

                Log.d("FlutterAmapView", "friendlyDistance: ${friendlyDistance}, ${friendlyTime}")
            }
        }

        override fun onBusRouteSearched(p0: BusRouteResult?, p1: Int) {

        }

        override fun onRideRouteSearched(result: RideRouteResult?, errorCode: Int) {
            // 骑行路线查询
        }

        override fun onWalkRouteSearched(p0: WalkRouteResult?, p1: Int) {

        }
    }
}