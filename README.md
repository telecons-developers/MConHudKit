# MConHudKit

[![CI Status](https://img.shields.io/travis/developers@telecons.co.kr/MConHudKit.svg?style=flat)](https://travis-ci.org/developers@telecons.co.kr/MConHudKit)
[![Version](https://img.shields.io/cocoapods/v/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)
[![License](https://img.shields.io/cocoapods/l/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)
[![Platform](https://img.shields.io/cocoapods/p/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)

## Installation

MConHudKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'MConHudKit'
```

## Authorization

Need Bluetooth Authorization
Add in info.plist
```
Privacy - Bluetooth Always Usage Description
Privacy - Bluetooth Peripheral Usage Description
```

## Auth

```swift
MConHudKit.shared.initialize(appKey: "appkey") { error in
  if let error = error {
    print("authorization fail \(error)")
    return
  }
  print("authorization success")
}
```

## Scan Device
```swift
// ViewController.swift
class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set Scan delegate
    MConHudKit.shared.hudScanDelegate = self
    // The Scanner will be automatically terminated after timeoutSec.
    // The Scanner will NOT be terminated if you pass nil to timeoutSec.
    MConHudKit.shared.startScanPeripheral(timeoutSec: 7)
  }
}
extension ViewController: MConHudScanDelegate {
    func scanPeripheral(peripherals: [MConHudPeripheral]) {
        peripherals.forEach { item in
            print(item.name)    // Device Name
            print(item.uuid)    // Device Identifier UUID
            print(item.rssi)    // Device Bluetooth rssi
            print(item.paired)  // Device Bluetooth Connect Status (Not BLE Connection)
        }
    }

    func scanTimeOut() {
        print("Scan time out. Scan end.")
    }
    func error(error: MConHudKitError) {
        print(error)
    }
}
```

## Bluetooth Connect Device
```swift
// peripheral is MConHudPeripheral
MConHudKit.shared.connectPeripheral(peripheral: peripheral)
```

```swift
// Connect Result
extension ViewController: MConHudScanDelegate {
    func connectPeripheralResult(peripheral: MConHudPeripheral) {
        // Connect Success
    }

    func error(error: MConHudKitError) {
        // Connect Fail
        print(error)
    }
}
```

## Bluetooth Disconnect Device
Bluetooth connection will be disconnected once turn off HUD device's power or call the following code. 
```swift
MConHudKit.shared.disconnectPeripheral(peripheral: peripheral)
```

You are to receive a disconnection signal through disconnectedPeripheral when the connection is terminated.
```swift
extension ViewController: MConHudScanDelegate {
    func disconnectedPeripheral() {
        print("disconnected")
    }
}
```

## Turn by turn Message
```swift
let turnByTurnCode: TurnByTurnCode = .straight
// distance unit is meter.
let distance = 200
MConHudKit.shared.sendTurnByTurnInfo(tbtCode: turnByTurnCode, distance: distance)
```

## Safety Message
```swift
let safetyCodes = [SafetyCode.camera]
MConHudKit.shared.sendSafetyInfo(
  safetyCodes: safetyCodes,    // Provide the camera types which is to be flashed in the form of an array.  
  limitSpeed: nil,             // If thee is a speed limit in the specific section, provide the speed limit as an integer,Int. if it is nil then speed restriction will be turned off..
  remainDistance: 215,         // Remaining distance (m)
  isOverSpeed: false           // If the current vehicle is speeding, pass 'true'. When HUD get 'true', it activates the speeding alert buzzer.
)
```

If the multiple safety indicators are to be flashed at the same time, provide the value for safetyCode in the form of an arrray.
```swift
let safetyCodes = [SafetyCode.camera, SafetyCode.signalCamera]
MConHudKit.shared.sendSafetyInfo(
  safetyCodes: safetyCodes,    // Provide the camera types which is to be flashed in the form of an array.
  limitSpeed: nil,             // If thee is a speed limit in the specific section, provide the speed limit as an integer,Int. if it is nil then speed restriction will be turned off.
  remainDistance: 215,         // Remaining distance (m)
  isOverSpeed: false           // If the current vehicle is speeding, pass 'true'. When HUD get 'true', it activates the speeding alert buzzer.
)
```

## Car Speed Message
```swift
let carSpeedCode: CarSpeedCode = .gpsSpeed
let speed = 100
MConHudKit.shared.sendCarSpeed(carSpeedCode: .gpsSpeed, speed: speed)
```

## Hud Brightness
Change the brightness of HUD
```swift
// has a low, medium, high
let brightnessLevel: BrightnessLevel = .low
MConHudKit.shared.sendHudBrightnessLevel(brightnessLevel: brightnessLevel)
```
Fetch the current status information for HUD's brightness status.
```swift
class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    MConHudKit.shared.hudDelegate = self
    MConHudKit.shared.getHudBuzzerLevel()
  }
}

extension ViewController: MConHudDelegate {
    func receiveHudBrightnessLevel(brightnessLevel: BrightnessLevel) {
        print(brightnessLevel)
    }
    func receiveHudBuzzerStatus(buzzerStatus: BuzzerStatus) {
        print(buzzerStatus)
    }
}
```

## Hud Buzzer
Change the beep sound volume of HUD.
```swift
// has a mute, low, medium, high
let buzzerLevel: BuzzerLevel = .low
MConHudKit.shared.sendHudBuzzerLevel(buzzerLevel: buzzerLevel)
```
Fetch the current status information for HUD's buzzer status.
Do NOT retrive the buzzer information in low, medium, or high but only obtain on/off status.
```swift
class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    MConHudKit.shared.hudDelegate = self
    MConHudKit.shared.getHudBuzzerLevel()
  }
}

extension ViewController: MConHudDelegate {
    func receiveHudBrightnessLevel(brightnessLevel: BrightnessLevel) {
        print(brightnessLevel)
    }
    func receiveHudBuzzerStatus(buzzerStatus: BuzzerStatus) {
        print(buzzerStatus)
    }
}
```

## Firmware Update
To be updated.

## License
N/A.
Update if needed.
