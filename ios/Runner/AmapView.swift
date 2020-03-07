//
//  AmapView.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import MAMapKit

class AmapView: NSObject, FlutterPlatformView {
    private var mapView: MAMapView!
    private let viewController: UIViewController
    private let param: AmapParam?
    
    init(_ viewController: UIViewController, param: AmapParam?) {
        self.viewController = viewController
        self.param = param
        super.init()
        self.initMapView()
        configMap()
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.viewController.view.bounds)
        self.viewController.view.addSubview(mapView!)
    }
    
    func configMap() {
        if let param = param {
            mapView.setZoomLevel(param.initialZoomLevel, animated: true)
        }
        if let centerPoint = param?.initialCenterPoint {
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: centerPoint[0], longitude: centerPoint[1]), animated: true)
        }
    }
}
