 [Changelog](https://github.com/kean/Nuke-AnimatedImage-Plugin/releases) for all versions

## Nuke AnimatedImage Plugin 2.0

Plugin has been updated to support Swift 3 and Nuke 4.

- Add `AnimatedImage.manager` that constructs default `Nuke.Manager` with support for animated images
- Add `AnimatedImageView` that implements `Nuke.Target` protocol
- `AnimatedImage` `data` is now nonnull (was explicitly unwrapped optional)
- `AnimatedImage` now implements `NSCoding` properly
- Remove `AnimatedImageProcessor`, uses new `makeProcessor` closure from `Nuke.Loader` class instead

## Nuke AnimatedImage Plugin 1.0

- Update to use Nuke 3.0+

## Nuke AnimatedImage Plugin 0.6

- #5 Instances of Nuke.AnimatedImage class no longer store references to instances of FLAnimatedImage class. It has multiple benefits: 
  - huge reduction in memory usage (in fact it's ~70% reduction in persistent memory usage, see the issue for more info
  - it's now easier to compute cost in mem. cache
  - prevents instance of FLAnimatedImage class from ever being reused in multiple views (based on https://github.com/Flipboard/FLAnimatedImage/issues/33)
- #7 Prepare FLAnimatedImage for rendering asynchronously
- #6 Add AnimatedImageMemoryCache that calculates cost of Nuke.AnimatedImage objects based on the size of underlying data (NSData) plus poster image bitmap size; It can also be used to disable animated images storage all together
