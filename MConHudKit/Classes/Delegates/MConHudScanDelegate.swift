//
//  HudScanDelegate.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/15.
//

import Foundation

public protocol MConHudScanDelegate: AnyObject {
    func scanPeripheral(peripherals: [MConHudPeripheral])
    func scanTimeOut()
    func connectPeripheralResult(peripheral: MConHudPeripheral)
    func disconnectedPeripheral()
    func error(error: MConHudKitError)
}
