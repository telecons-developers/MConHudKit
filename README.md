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
    // timeoutSec 후 Scanner가 자동 종료 됩니다.
    // timeoutSec에 nil을 전달하면 Scanner가 자동 종료 되지 않습니다.
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
HUD 디바이스의 전원을 Off시키거나 아래 코드를 호출하면 블루투스 연결이 해제됩니다.
```swift
MConHudKit.shared.disconnectPeripheral(peripheral: peripheral)
```

연결이 해제되면 disconnectedPeripheral를 통해 연결 해제 신호를 받을 수 있습니다.
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
// distance는 meter단위 입니다.
let distance = 200
MConHudKit.shared.sendTurnByTurnInfo(tbtCode: turnByTurnCode, distance: distance)
```

## Safety Message
```swift
let safetyCodes = [SafetyCode.camera]
MConHudKit.shared.sendSafetyInfo(
  safetyCodes: safetyCodes,    // 점등하고자 하는 카메라 타입을 Array형태로 전달해 주세요.
  limitSpeed: nil,             // 해당 구간에 제한속도가 있다면 제한 속도를 Int로 전달해 주세요. nil일 경우 제한속도등을 Off 합니다.
  remainDistance: 215,         // 남은거리 (m)
  isOverSpeed: false           // 현재 차량이 과속 중일 경우 true로 전달해 주세요. Hud의 true일 경우 과속 경고 Buzzer가 재생 됩니다.
)
```

복수개의 안전운전등을 한번에 점등하고 싶으면 아래와 같이 safetyCodes에 Array 형태로 값을 전달해 주세요.
```swift
let safetyCodes = [SafetyCode.camera, SafetyCode.signalCamera]
MConHudKit.shared.sendSafetyInfo(
  safetyCodes: safetyCodes,    // 점등하고자 하는 카메라 코드를 배열로 전달해 주세요.
  limitSpeed: nil,             // 해당 구간에 제한속도가 있다면 제한 속도를 Int로 전달해 주세요. nil일 경우 제한속도등을 Off 합니다.
  remainDistance: 215,         // 남은거리 (m)
  isOverSpeed: false           // 현재 차량이 과속 중일 경우 true로 전달해 주세요. Hud의 true일 경우 과속 경고 Buzzer가 재생 됩니다.
)
```

## Car Speed Message
```swift
let carSpeedCode: CarSpeedCode = .gpsSpeed
let speed = 100
MConHudKit.shared.sendCarSpeed(carSpeedCode: .gpsSpeed, speed: speed)
```

## Hud Brightness
Hud 밝기 변경
```swift
// has a low, medium, high
let brightnessLevel: BrightnessLevel = .low
MConHudKit.shared.sendHudBrightnessLevel(brightnessLevel: brightnessLevel)
```
현재 Hud의 밝기 정보 조회
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
Hud 비프음 크기 변경
```swift
// has a mute, low, medium, high
let buzzerLevel: BuzzerLevel = .low
MConHudKit.shared.sendHudBuzzerLevel(buzzerLevel: buzzerLevel)
```
현재 Hud의 Buzzer Status 정보 조회
Buzzer는 low, medium, high정보를 조회할 수 없으며 on/off여부만 확인할 수 있습니다.
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
추 후 업데이트 예정입니다.

## License
없음.
필요 시 업데이트.
