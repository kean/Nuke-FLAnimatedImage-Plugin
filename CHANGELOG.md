# Nuke FLAnimatedImage Plugin 5.0

Updated for Nuke 7

# Nuke FLAnimatedImage Plugin 4.0

A primary focus of this release is to update the project to Swift 4.1.  **Requires a few small migrations steps**. See the list of changes for more info:

## Updated to Swift 4.1

Removed `AnimatedImage` class which was `UIImage` subclass and caused [all sorts of problems](https://github.com/kean/Nuke-Gifu-Plugin/issues/7) while upgrading to new Swift versions.

<hr/>

Removed:

```swift
public class AnimatedImage: UIImage {
    public let data: Data
    public init(data: Data, poster: CGImage)
}
```

Added (please use instead):

```swift
extension UIImage {
    // Animated image data. Only not `nil` when image data actually contains
    // an animated image.
    public var animatedImageData: Data? { get set }
}
```

<hr/>

Removed:

```swift
extension AnimatedImage {
    /// Default `Nuke.Manager` with animated GIF support.
    public let manager: Nuke.Manager { get }
}
```

Added (please use instead):

```swift
extension Nuke.Manager {
    /// Default `Nuke.Manager` with animated GIF support.
    public let animatedImageManager: Nuke.Manager { get }
}
```

## Other Changes

- Update demo to Swift 4.1
- Replace `Nuke.Cache` method `func preparedForAnimatedImages() -> Self` with `func prepareForAnimatedImages()` which makes it clear that the API doesn't return a new instance.
- Add `Nuke.Loader.Options` method `func prepareForAnimatedImages()` symmetric to existing cache extension.

# Nuke FLAnimatedImage Plugin 3.0

Updated for Nuke 6.

# Nuke FLAnimatedImage Plugin 2.0

Plugin has been updated to support Swift 3 and Nuke 4. It has also been renamed to "Nuke FLAnimatedImage Plugin" (which it should have been in the first place).

- Add `AnimatedImage.manager` that constructs default `Nuke.Manager` with support for animated images
- Add `AnimatedImageView` that implements `Nuke.Target` protocol
- `AnimatedImage` `data` is now nonnull (was explicitly unwrapped optional)
- `AnimatedImage` now implements `NSCoding` properly
- Remove `AnimatedImageProcessor`, uses new `makeProcessor` closure from `Nuke.Loader` class instead

# Nuke AnimatedImage Plugin 1.0

- Update to use Nuke 3.0+

# Nuke AnimatedImage Plugin 0.6

- #5 Instances of Nuke.AnimatedImage class no longer store references to instances of FLAnimatedImage class. It has multiple benefits: 
  - huge reduction in memory usage (in fact it's ~70% reduction in persistent memory usage, see the issue for more info
  - it's now easier to compute cost in mem. cache
  - prevents instance of FLAnimatedImage class from ever being reused in multiple views (based on https://github.com/Flipboard/FLAnimatedImage/issues/33)
- #7 Prepare FLAnimatedImage for rendering asynchronously
- #6 Add AnimatedImageMemoryCache that calculates cost of Nuke.AnimatedImage objects based on the size of underlying data (NSData) plus poster image bitmap size; It can also be used to disable animated images storage all together
