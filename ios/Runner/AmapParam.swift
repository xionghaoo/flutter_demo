//
//  AmapParam.swift
//  Runner
//
//  Created by xionghao on 2020/3/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

struct AmapParam: Codable {
    let initialCenterPoint: Array<Double>
    let initialZoomLevel: CGFloat
    
    init(initialCenterPoint: Array<Double>, initialZoomLevel: CGFloat) {
        self.initialCenterPoint = initialCenterPoint
        self.initialZoomLevel = initialZoomLevel
    }
}
