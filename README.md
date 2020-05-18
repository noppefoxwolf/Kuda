# Kuda

![](https://github.com/noppefoxwolf/Kuda/blob/master/.github/preview.gif)

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
