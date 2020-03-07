//
//  TextViewPlugin.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class TextViewPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let viewFactory = TextViewFactory(registrar.messenger())
        registrar.register(viewFactory, withId: "xh.zero/textview")
    }
}
