package xh.zero.flutter_demo.plugins.amap

import android.content.Context
import android.util.Log
import com.amap.api.maps.AMap
import com.amap.api.services.core.AMapException
import com.amap.api.services.route.*
import com.ks.amap.AMapUtil
import com.ks.amap.DrivingRouteOverlay
import com.ks.amap.RideRouteOverlay
import xh.zero.flutter_demo.R

class RouteMapImpl(
    private val context: Context?,
    private val aMap: AMap?,
    private val param: AmapParam
) : IActualMap {

    private val rideRouteOverlayList = ArrayList<RideRouteOverlay>()
    private val driverRouteOverlayList = ArrayList<DrivingRouteOverlay>()

    override fun onCreate() {
        drawRoutePaths()
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