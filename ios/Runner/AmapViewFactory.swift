//
//  AmapViewFactory.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import SwiftyJSON

class AmapViewFactory: NSObject, FlutterPlatformViewFactory {
    let messenger: FlutterBinaryMessenger
    let viewController: UIViewController
    init(_ messenger: FlutterBinaryMessenger, vc: UIViewController) {
        self.messenger = messenger
        self.viewController = vc
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
//        do {
//            if let param = args! as? String {
//                let data = param.data(using: .utf8)!
//                print("args: \(param)")
//                let jsonObj: Any? = try JSONSerialization.jsonObject(with: data, options: [])
////                let initialCenterPointJson = (jsonObj as? [String:Any])!
////                let initialCenterPoint = initialCenterPointJson["initialCenterPoint"] as? Array<Double>
//                print("jsonObj: \(jsonObj)")
//            }
//        } catch let error {
//            print("has error: \(error)")
//        }
        print("args: \(args!)")
        var amapParam: AmapParam? = nil
        do {
            if let param = args! as? String,
                let jsonData = param.data(using: .utf8, allowLossyConversion: false) {
                amapParam = try JSONDecoder().decode(AmapParam.self, from: jsonData)
            }
        } catch let e {
            print("has error: \(e)")
        }
        return AmapView(viewController, param: amapParam)
    }
    
    // 为地图创建消息解码器，和dart端保持一致
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
