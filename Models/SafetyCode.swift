//
//  SafetyCode.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/25.
//

import Foundation

public enum SafetyCode: Int{
    case camera = 1                 // 카메라
    case speedAndSignalCamera = 2   // 신호 과속 카메라
    case protectChildren = 4        // 어린이 보호 구역
    case noParking = 8              // 주차 금지
    case busOnly = 16               // 버스 전용 차로
    case sectionCamera = 32         // 구간 단속
    case signalCamera = 64          // 신호 단속
}
