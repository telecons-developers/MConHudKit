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



## Car Speed Message

## Hud Brightness

## Hud Buzzer

## Firmware Update
추 후 업데이트 예정입니다.

## License

MConHudKit is available under the MIT license. See the LICENSE file for more info.
