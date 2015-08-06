# Eddystone CocoaPod

[![CI Status](http://img.shields.io/travis/Tanner Nelson/Eddystone.svg?style=flat)](https://travis-ci.org/Tanner Nelson/Eddystone)
[![Version](https://img.shields.io/cocoapods/v/Eddystone.svg?style=flat)](http://cocoapods.org/pods/Eddystone)
[![License](https://img.shields.io/cocoapods/l/Eddystone.svg?style=flat)](http://cocoapods.org/pods/Eddystone)
[![Platform](https://img.shields.io/cocoapods/p/Eddystone.svg?style=flat)](http://cocoapods.org/pods/Eddystone)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Nearby URLs

To fetch nearby URLs, simply start the scanner

```swift
Eddystone.Scanner.start(self)
```

Then get an array of the URLs with

```swift
Eddystone.Scanner.urls()
```

To start the scanner, you will need to provide a `Eddystone.ScannerDelegate` delegate that will be notified to changes in the nearby URLs

```swift
public protocol ScannerDelegate {
    func eddystoneUrlsDidChange()
}
```

## Requirements

Eddystone uses CoreBluetooth

## Installation

Eddystone is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Eddystone"
```

## Author

Tanner Nelson, tanner@bluebite.com

## License

Eddystone is available under the MIT license. See the LICENSE file for more info.
