package xh.zero.flutter_demo.plugins

class AmapParam {
    val initialCenterPoint: ArrayList<Double>? = null
    val initialZoomLevel: Float? = null
    val enableMyLocation: Boolean = false
    val enableMyMarker: Boolean = false

    val startAddressList: ArrayList<AddressInfo>? = null
    val endAddressList: ArrayList<AddressInfo>? = null

    class AddressInfo {
        val geo: GeoPoint? = null
        val address: String? = null
    }

    class GeoPoint(val lat: Double, val lng: Double)
}