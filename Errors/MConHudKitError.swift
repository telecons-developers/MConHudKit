//
//  MConHudKitError.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/25.
//

import Foundation

public enum MConHudKitError: Error {
    case invalidAuthorization
    case bluetoothPermissionDenied
    case peripheralConnectFail
}
