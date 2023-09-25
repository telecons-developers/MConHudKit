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
    print("authorization fail \(error
    return
  }
  print("authorization success")
}
```

## License

MConHudKit is available under the MIT license. See the LICENSE file for more info.
