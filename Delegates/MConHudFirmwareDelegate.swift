//
//  MConHudFirmwareDelegate.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/15.
//

import Foundation

public protocol MConHudFirmwareDelegate: AnyObject {
    func receiveFirmwareInfo(firmwareInfo: FirmwareInfo)
    func firmwareUpdate(progress: Int)
    func firmwareUpdateComplete(firmwareInfo: FirmwareInfo)
    func firmwareUpdateError(firmwareUpdateError: MConHudKitError)
}
