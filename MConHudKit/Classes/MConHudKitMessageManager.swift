//
//  MConHudKitMessageManager.swift
//  MConHudKit
//
//  Created by 정지성 on 2023/09/25.
//

import Foundation

final class MConHudMessageManager: NSObject {
    private let header = "19"
    private let write_id = "4D"
    private let fw_id = "4F"
    private let tail = "2F"
    
    func tbtMessage(turnByTurnCode: TurnByTurnCode, distance: Int) -> String {
        return "\(header)\(write_id)0105\(toTbtData(turnByTurnCode: turnByTurnCode))\(Int(distance).toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 6, withPad: "0"))\(tail)"
    }
    func safetyMessage(safetyCodes: [SafetyCode], limitSpeed: Int?, remainDistance: Int, isOverSpeed: Bool) -> String {
        var cameraType = 0
        safetyCodes.forEach { item in
            cameraType += item.rawValue
        }
        var onViolation = 0
        if isOverSpeed {
            onViolation = 1
        }
        var speed = 0
        
        if let limitSpeed = limitSpeed {
            speed = limitSpeed
        }

        return "\(header)\(write_id)0206\(cameraType.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0"))\(speed.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0"))\(onViolation.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0"))\(remainDistance.toHexString().leftPadding(toLength: 6, withPad: "0"))\(tail)"
    }
    func carSpeedMessage(carSpeedCode: CarSpeedCode, speed: Int) -> String {
        var type = 0
        if carSpeedCode == .sectionAverageSpeed {
            type = 1
        }
        let speedType = type.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        let carSpeed = speed.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        return "\(header)\(write_id)0302\(speedType)\(carSpeed)\(tail)"
    }
    func clearMessage( clearCodes: [ClearCode] ) -> String {
        var clearType = 0
        clearCodes.forEach { item in
            clearType += item.rawValue
        }
        let turnOffCode = clearType.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        return "\(header)\(write_id)0501\(turnOffCode)\(tail)"
    }
    
    func deviceInfoMessage(deviceInfoType: DeviceInfoType) -> String {
        let settingType = deviceInfoType.rawValue.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        return "\(header)\(write_id)0601\(settingType)\(tail)"
    }
    
    func brightnessMessage(brightnessLevel: BrightnessLevel) -> String {
        let dayMessage = brightnessLevel.rawValue.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        return "\(header)\(write_id)0702\(dayMessage)\(dayMessage)\(tail)"
    }
    
    func buzzerLevelMessage(buzzerLevel: BuzzerLevel) -> String {
        var soundPower = 0
        
        if buzzerLevel != .mute {
            soundPower = 1
        }
        let soundOnOffMessage = soundPower.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        let soundLevelMessage = buzzerLevel.rawValue.toHexString().replacingOccurrences(of: " ", with: "").leftPadding(toLength: 2, withPad: "0")
        
        return "\(header)\(write_id)0802\(soundOnOffMessage)\(soundLevelMessage)\(tail)"
    }
    
    private func toTbtData(turnByTurnCode: TurnByTurnCode) -> String {
        switch turnByTurnCode {
        case .straight: return "0000"
        case .leftTurn: return "0002"
        case .rightTurn: return "0005"
        case .uTurn: return "0007"
        case .sharpLeftTurn: return "0003"
        case .sharpRightTurn: return "0004"
        case .curveLeftTurn: return "0001"
        case .curveRightTurn: return "0006"
        case .leftOutHighway: return "000A"
        case .rightOutHighway: return "000B"
        case .leftInHighway : return "0008"
        case .rightInHighway: return "0009"
        case .tunnel: return "000E"
        case .overPath: return "000F"
        case .underPath: return "0011"
        case .overPathSide: return "0010"
        case .underPathSide: return "0012"
        case .tollgate: return "000C"
        case .restarea: return "000D"
        case .rotaryDirection_1: return "0104"
        case .rotaryDirection_2: return "0104"
        case .rotaryDirection_3: return "0105"
        case .rotaryDirection_4: return "0106"
        case .rotaryDirection_5: return "0106"
        case .rotaryDirection_6: return "0107"
        case .rotaryDirection_7: return "0101"
        case .rotaryDirection_8: return "0101"
        case .rotaryDirection_9: return "0102"
        case .rotaryDirection_10: return "0103"
        case .rotaryDirection_11: return "0103"
        case .rotaryDirection_12: return "0100"
        }
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
    func toHexString() -> String {
        let data = self.data(using: .utf8)!
        return data.map{ String(format:"%02x", $0) }.joined().uppercased()
    }
    func getHexStringLength() -> Int {
        return self.utf8.count
    }
}
extension Int {
    func toHexString() -> String {
        return NSString(format:"%2X", self) as String
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
