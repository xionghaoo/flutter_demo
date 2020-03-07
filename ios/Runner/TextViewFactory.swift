//
//  TextViewFactory.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class TextViewFactory : NSObject, FlutterPlatformViewFactory {
    
    let messenger: FlutterBinaryMessenger
    init(_ messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        print("create frame: \(frame)")
        return FlutterTextView(frame: frame, id: viewId, messenger: messenger)
    }
}
