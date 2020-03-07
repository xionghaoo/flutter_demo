//
//  TextView.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class FlutterTextView: NSObject, FlutterPlatformView {
    private var channel: FlutterMethodChannel?
    private let label: UILabel!
    let frame: CGRect
    
    init(frame: CGRect, id: Int64, messenger: FlutterBinaryMessenger) {
        self.frame = frame
        print("frame \(frame)")
        self.label = UILabel(frame: frame)
        super.init()
       
        self.channel = FlutterMethodChannel(name: "xh.zero/textview_\(id)", binaryMessenger: messenger)
        self.channel?.setMethodCallHandler {[weak self] (call, result) in
            if (call.method == "setText") {
                let argument = call.arguments as? String
                self?.label.text = argument
            }
        }
    }
    
    func view() -> UIView {
        print("getView")
        return label
    }

}
