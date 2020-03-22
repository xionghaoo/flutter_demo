//
//  AmapParam.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

//enum MapType: Int {
//   case routeMap = 0
//   case addressDescriptionMap = 1
//}

class AmapParam: Codable {
    
    static let routeMap: Int = 0
    static let addressDescriptionMap: Int = 0
    
    let initialCenterPoint: Array<Double>
    let initialZoomLevel: CGFloat
    let enableMyLocation: Bool?
    let enableMyMarker: Bool?
    let mapType: Int
    let startAddressList: Array<AddressInfo>?
    let endAddressList: Array<AddressInfo>?
    
    init(
        initialCenterPoint: Array<Double>,
        initialZoomLevel: CGFloat,
        enableMyLocation: Bool? = false,
        enableMyMarker: Bool? = false,
        mapType: Int = routeMap,
        startAddressList: Array<AddressInfo>? = [],
        endAddressList: Array<AddressInfo>? = []
    ) {
        self.initialCenterPoint = initialCenterPoint
        self.initialZoomLevel = initialZoomLevel
        self.enableMyLocation = enableMyLocation
        self.enableMyMarker = enableMyMarker
        self.mapType = mapType
        self.startAddressList = startAddressList
        self.endAddressList = endAddressList
    }
}

struct AddressInfo: Codable {
    let geo: GeoPoint?
    let address: String?
}

struct GeoPoint: Codable {
    let lat: Double?
    let lng: Double?
}
