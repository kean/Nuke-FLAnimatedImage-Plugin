<p align="center"><img src="https://cloud.githubusercontent.com/assets/1567433/13918338/f8670eea-ef7f-11e5-814d-f15bdfd6b2c0.png" height="180"/>

<p align="center">
<a href="https://cocoapods.org"><img src="https://img.shields.io/cocoapods/v/Nuke-Alamofire-Plugin.svg"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
</p>

[FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) plugin for [Nuke](https://github.com/kean/Nuke) that allows you to load and display animated GIFs with [smooth scrolling performance and low memory footprint](https://www.youtube.com/watch?v=fEJqQMJrET4).


## Usage

The plugin features a pre-configured `Nuke.Manager` with GIF support, and an `AnimatedImageView`:

```swift
let view = AnimatedImageView()
AnimatedImage.manager.loadImage(with: URL(string: "http://...")!, into: view)
```

## Installation

### [CocoaPods](http://cocoapods.org)

To install the plugin add a dependency to your Podfile:

```ruby
# source 'https://github.com/CocoaPods/Specs.git'
# use_frameworks!

pod "Nuke-FLAnimatedImage-Plugin"
```

### [Carthage](https://github.com/Carthage/Carthage)

To install the plugin add a dependency to your Cartfile:

```
github "kean/Nuke-FLAnimatedImage-Plugin"
```

## Requirements

- iOS 9
- Xcode 8
- Swift 3

## Dependencies

- [Nuke 4.x](https://github.com/kean/Nuke)
- [FLAnimatedImage 1.x](https://github.com/Flipboard/FLAnimatedImage)

## License

Nuke is available under the MIT license. See the LICENSE file for more info.
