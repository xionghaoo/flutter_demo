//
//  AmapPlugin.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

class AmapPlugin: NSObject, FlutterPlugin {
    
//    private var controller: UIViewController
//
//    init(registrar: FlutterPluginRegistrar) {
//        self.controller = (UIApplication.shared.delegate?.window?!.rootViewController)!
//        self.messenger = registrar.messenger()
//    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let controller = (UIApplication.shared.delegate?.window?!.rootViewController)!
        let viewFactory = AmapViewFactory(registrar.messenger(), vc: controller)
        registrar.register(viewFactory, withId: "xh.zero/amap")
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
}
