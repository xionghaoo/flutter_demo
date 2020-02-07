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
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "xh.zero/version", binaryMessenger: registrar.messenger())
        let instance = BuildConfigPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getApplicationVersion") {
            // 获取应用版本
            result(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
};
