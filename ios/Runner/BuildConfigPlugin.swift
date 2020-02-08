//
//  BuildConfigPlugin.swift
//  Runner
//
//  Created by xionghao on 2020/2/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import Flutter
import UIKit

class BuildConfigPlugin: NSObject, FlutterPlugin {
    
    private var channel: FlutterMethodChannel
    private var controller: UIViewController
    
    init(registrar: FlutterPluginRegistrar) {
        self.controller = (UIApplication.shared.delegate?.window?!.rootViewController)!
        self.channel = FlutterMethodChannel(name: "xh.zero/version", binaryMessenger: registrar.messenger())
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        //        let channel = FlutterMethodChannel(name: "xh.zero/version", binaryMessenger: registrar.messenger())
        let instance = BuildConfigPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getApplicationVersion") {
            // 获取应用版本
            result(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
            
            self.channel.invokeMethod("callFlutter", arguments: nil, result: { result in
                print("result is: \(type(of: result!))") //__NSCFString
                let alert = UIAlertController(title: "Received", message: "\(result!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                }))
                self.controller.present(alert, animated: true, completion: nil)
            })
        } else {
            result(FlutterMethodNotImplemented)
        }
        
    }
    
    
};
