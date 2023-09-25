//
//  MConHudDelegate.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/15.
//

import Foundation

public protocol MConHudDelegate: AnyObject {
    func receiveHudBrightnessLevel(brightnessLevel: BrightnessLevel)
    func receiveHudBuzzerStatus(buzzerStatus: BuzzerStatus)
}
