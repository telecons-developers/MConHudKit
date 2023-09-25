# MConHudKit

[![CI Status](https://img.shields.io/travis/developers@telecons.co.kr/MConHudKit.svg?style=flat)](https://travis-ci.org/developers@telecons.co.kr/MConHudKit)
[![Version](https://img.shields.io/cocoapods/v/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)
[![License](https://img.shields.io/cocoapods/l/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)
[![Platform](https://img.shields.io/cocoapods/p/MConHudKit.svg?style=flat)](https://cocoapods.org/pods/MConHudKit)

## Installation

MConHudKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MConHudKit'
```

## Authorization

Need Bluetooth Authorization
Add in info.plist
```ruby
Privacy - Bluetooth Always Usage Description
Privacy - Bluetooth Peripheral Usage Description
```

## Auth

```ruby
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
#ViewController.swift
class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
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

    func connectPeripheralResult(peripheral: MConHudPeripheral) {
    }

    func disconnectedPeripheral() {
    }

    func error(error: MConHudKitError) {
        print(error)
    }
}
```

## License

MConHudKit is available under the MIT license. See the LICENSE file for more info.
