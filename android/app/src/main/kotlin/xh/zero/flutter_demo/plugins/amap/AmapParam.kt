package xh.zero.flutter_demo.plugins.amap

class AmapParam {
    val initialCenterPoint: ArrayList<Double>? = null
    val initialZoomLevel: Float? = null
    val enableMyLocation: Boolean = false
    val enableMyMarker: Boolean = false
    val mapType: Int? = ROUTE_MAP

    val startAddressList: ArrayList<AddressInfo>? = null
    val endAddressList: ArrayList<AddressInfo>? = null

    class AddressInfo {
        val geo: GeoPoint? = null
        val address: String? = null
    }

    class GeoPoint(val lat: Double, val lng: Double)

    companion object {
        const val ROUTE_MAP: Int = 0
        const val ADDRESS_DESCRIPTION_MAP: Int = 1
    }
}