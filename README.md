# Kuda

[![CI Status](https://img.shields.io/travis/noppe/Kuda.svg?style=flat)](https://travis-ci.org/noppe/Kuda)
[![Version](https://img.shields.io/cocoapods/v/Kuda.svg?style=flat)](https://cocoapods.org/pods/Kuda)
[![License](https://img.shields.io/cocoapods/l/Kuda.svg?style=flat)](https://cocoapods.org/pods/Kuda)
[![Platform](https://img.shields.io/cocoapods/p/Kuda.svg?style=flat)](https://cocoapods.org/pods/Kuda)

## Usage

```swift
Kuda.install(debuggerItems: [
  CustomSuccessDebugItem(),
  CustomFailureDebugItem(),
  UIDebugItem({ UISwitch() }),
  UIDebugItem({ ExampleViewController(rootView: ExampleView()) }),
  ViewControllerDebugItem({ ExampleViewController(rootView: ExampleView()) }),
  CaseSelectableDebugItem(currentValue: Animal.dog, didSelected: { print($0) }),
  InfoDebugItem(),
  ExitDebugItem(),
])
```

## Requirements

## Installation

Kuda is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Kuda'
```

## Author

noppe, noppelabs@gmail.com

## License

Kuda is available under the MIT license. See the LICENSE file for more info.
