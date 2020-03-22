//
//  AmapView.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class AmapView: NSObject, FlutterPlatformView, MAMapViewDelegate, AMapSearchDelegate {
    private var mapView: MAMapView!
    private let viewController: UIViewController
    private let param: AmapParam?
    var search: AMapSearchAPI!
    
    var startCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var naviRoute: MANaviRoute?
    var route: AMapRoute?
    var currentSearchType: AMapRoutePlanningType = AMapRoutePlanningType.drive
    
    init(_ viewController: UIViewController, param: AmapParam?) {
        self.viewController = viewController
        self.param = param
        super.init()
        
        if let startAddrList = param?.startAddressList,
            startAddrList.count > 0,
            let geo = startAddrList.first?.geo {
            startCoordinate = CLLocationCoordinate2DMake(geo.lat ?? 0.0, geo.lng ?? 0.0)
        }
        if let endAddrList = param?.endAddressList,
            endAddrList.count > 0,
            let geo = endAddrList.first?.geo {
            destinationCoordinate = CLLocationCoordinate2DMake(geo.lat ?? 0.0, geo.lng ?? 0.0)
        }
        
        initMapView()
        initSearch()
        configMap()
        addDefaultAnnotations()
        
        currentSearchType = AMapRoutePlanningType.drive
        searchRoutePlanningDrive()
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func initMapView() {
        mapView = MAMapView(frame: self.viewController.view.bounds)
        mapView.delegate = self
        self.viewController.view.addSubview(mapView!)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    func configMap() {
        // 设置缩放等级
        if let param = param {
            mapView.setZoomLevel(param.initialZoomLevel, animated: true)
        }
        // 设置地图中心
        if let centerPoint = param?.initialCenterPoint {
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: centerPoint[0], longitude: centerPoint[1]), animated: true)
        }
        
    }
    
    func addDefaultAnnotations() {

          let anno = MAPointAnnotation()
          anno.coordinate = startCoordinate
          anno.title = "起点"
          
          mapView.addAnnotation(anno)
          
          let annod = MAPointAnnotation()
          annod.coordinate = destinationCoordinate
          annod.title = "终点"
          
          mapView.addAnnotation(annod)
      }
    
    func searchRoutePlanningDrive() {
        let request = AMapDrivingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
        
        request.requireExtension = true
        
        search.aMapDrivingRouteSearch(request)
    }
    
    /* 展示当前路线方案. */
    func presentCurrentCourse() {
        
        let start = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        let end = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
        
        if currentSearchType == .bus || currentSearchType == .busCrossCity {
            naviRoute = MANaviRoute(for: route?.transits.first, start: start, end: end)
        } else {
            let type = MANaviAnnotationType(rawValue: currentSearchType.rawValue)
            naviRoute = MANaviRoute(for: route?.paths.first, withNaviType: type!, showTraffic: true, start: start, end: end)
        }
        
        naviRoute?.add(to: mapView)
        
        mapView.showOverlays(naviRoute?.routePolylines, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }
    
    // MARK: - MAMapViewDelegate
    // 渲染路径
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: LineDashPolyline.self) {
            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.red
            renderer.lineDashType = MALineDashType.square
            
            return renderer
        }
        if overlay.isKind(of: MANaviPolyline.self) {
            
            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            
            if naviPolyline.type == MANaviAnnotationType.walking {
                renderer.strokeColor = naviRoute?.walkingColor
            }
            else if naviPolyline.type == MANaviAnnotationType.railway {
                renderer.strokeColor = naviRoute?.railwayColor;
            }
            else {
                renderer.strokeColor = naviRoute?.routeColor;
            }
            
            return renderer
        }
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(multiPolyline: overlay as! MAMultiPolyline?)
            renderer.lineWidth = 8.0
            renderer.strokeColors = naviRoute?.multiPolylineColors
            
            return renderer
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView!.canShowCallout = true
                annotationView!.isDraggable = false
            }
            
            annotationView!.image = nil
            
            if annotation.isKind(of: MANaviAnnotation.self) {
                let naviAnno = annotation as! MANaviAnnotation
                
                switch naviAnno.type {
                case MANaviAnnotationType.railway:
                    annotationView!.image = UIImage(named: "railway_station")
                    break
                case MANaviAnnotationType.drive:
                    annotationView!.image = UIImage(named: "car")
                    break
                case MANaviAnnotationType.riding:
                    annotationView!.image = UIImage(named: "ride")
                    break
                case MANaviAnnotationType.walking:
                    annotationView!.image = UIImage(named: "man")
                    break
                case MANaviAnnotationType.bus:
                    annotationView!.image = UIImage(named: "bus")
                    break
                case .truck:
                    annotationView!.image = UIImage(named: "truck")
                    break
                case .futureDrive:
                    annotationView!.image = UIImage(named: "car")
                    break
                @unknown default:
                    print("unkown type")
                }
            }
            else {
                if annotation.title == "起点" {
                    annotationView!.image = UIImage(named: "startPoint")
                }
                else if annotation.title == "终点" {
                    annotationView!.image = UIImage(named: "endPoint")
                }
            }
            return annotationView!
        }
        
        return nil
    }
    
    // MARK: - AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        // 检索失败
        //        let nsErr:NSError? = error as NSError
        //        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
        print("Error: \(error)")
    }
    
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        // 当检索成功时，会进到 onRouteSearchDone 回调函数中
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        addDefaultAnnotations()
        
        self.route = nil
        if response.count > 0 {
            
            self.route = response.route
            presentCurrentCourse()
        }
    }
}
