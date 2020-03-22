package xh.zero.flutter_demo.plugins.amap

import android.os.Parcel
import android.os.Parcelable
import com.amap.api.services.core.LatLonPoint

data class PoiAddress(
    val id: Int = -1,
    val title: String?,
    val address: String?,
    var displayAddress: String? = null,
    val geo: LatLonPoint?,
    val provinceName: String?,
    var provinceCode: String?,
    val cityName: String?,
    val cityCode: String?,
    val districtName: String?,
    val districtCode: String?,
    val buildingName: String?
) : Parcelable {

    private constructor(parcel: Parcel?) : this(
        parcel?.readInt() ?: -1,
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readParcelable(LatLonPoint::class.java.classLoader),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString(),
        parcel?.readString()
    )

    override fun writeToParcel(dest: Parcel?, flags: Int) {
        dest?.writeInt(id)
        dest?.writeString(title)
        dest?.writeString(address)
        dest?.writeString(displayAddress)
        dest?.writeParcelable(geo, flags)
        dest?.writeString(provinceName)
        dest?.writeString(provinceCode)
        dest?.writeString(cityName)
        dest?.writeString(cityCode)
        dest?.writeString(districtName)
        dest?.writeString(districtCode)
        dest?.writeString(buildingName)
    }

    override fun describeContents(): Int = 0

    companion object {
        @JvmField
        val CREATOR = object : Parcelable.Creator<PoiAddress> {
            override fun createFromParcel(source: Parcel?): PoiAddress {
                return PoiAddress(source)
            }

            override fun newArray(size: Int): Array<PoiAddress?> {
                return arrayOfNulls<PoiAddress>(size)
            }
        }
    }
}