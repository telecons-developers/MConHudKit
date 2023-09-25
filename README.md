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
```ruby
#ViewController.swift

var list = [MConHudPeripheral]()
override func viewDidLoad() {
  super.viewDidLoad()
  MConHudKit.shared.hudScanDelegate = self
  MConHudKit.shared.startScanPeripheral(timeoutSec: 7)
}

extension ViewController: MConHudScanDelegate {
    func scanPeripheral(peripherals: [MConHudPeripheral]) {
        self.list = peripherals
    }

    func scanTimeOut() {
        print("Scan Time out!")
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
