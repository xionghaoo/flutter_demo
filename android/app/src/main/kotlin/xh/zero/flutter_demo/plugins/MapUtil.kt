package xh.zero.flutter_demo.plugins

import com.amap.api.services.core.LatLonPoint

class MapUtil {
    companion object {
        fun convertGeoPointToLatLonPoint(geo: AmapParam.GeoPoint?) : LatLonPoint {
            if (geo == null) {
                return LatLonPoint(0.0, 0.0)
            } else {
                return LatLonPoint(geo.lat, geo.lng)
            }
        }

    }
}