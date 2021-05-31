<p align="center"><img src="https://cloud.githubusercontent.com/assets/1567433/13918338/f8670eea-ef7f-11e5-814d-f15bdfd6b2c0.png" height="180"/>

[FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) plugin for [Nuke](https://github.com/kean/Nuke) that allows you to load and display animated GIFs with [smooth scrolling performance](https://www.youtube.com/watch?v=fEJqQMJrET4) and low memory footprint. You can see it for yourself in a demo, included in the project.

## Usage

All you need to do to enable GIF support is set `isAnimatedImageDataEnabled` to `true`. After you do that, you can start using `FLAnimatedImageView`.

```swift
let view = FLAnimatedImageView()
Nuke.loadImage(with: URL(string: "http://.../cat.gif")!, into: view)
```

## Minimum Requirements

| Nuke FLAnimatedImage Plugin            | Swift                 | Xcode                | Platforms   |
|----------------------------------------|-----------------------|----------------------|-------------|
| Nuke FLAnimatedImage Plugin 8.0      | Swift 5.3       | Xcode 12.0      | iOS 11.0 / tvOS 11.0    |
| Nuke FLAnimatedImage Plugin 7.0      | Swift 5.1       | Xcode 11.0      | iOS 11.0    |
 
## Dependencies

- [Nuke ~> 10.0](https://github.com/kean/Nuke)
- [FLAnimatedImage ~> 1.0](https://github.com/Flipboard/FLAnimatedImage)

## License

Nuke is available under the MIT license. See the LICENSE file for more info.
