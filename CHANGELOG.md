 [Changelog](https://github.com/kean/Nuke-AnimatedImage-Plugin/releases) for all versions

## Nuke AnimatedImage Plugin 0.6.0

- #5 Instances of Nuke.AnimatedImage class no longer store references to instances of FLAnimatedImage class. It has multiple benefits: 
  - huge reduction in memory usage (in fact it's ~70% reduction in persistent memory usage, see the issue for more info
  - it's now easier to compute cost in mem. cache
  - prevents instance of FLAnimatedImage class from ever being reused in multiple views (based on https://github.com/Flipboard/FLAnimatedImage/issues/33)
- #7 Prepare FLAnimatedImage for rendering asynchronously
- #6 Add AnimatedImageMemoryCache that calculates cost of Nuke.AnimatedImage objects based on the size of underlying data (NSData) plus poster image bitmap size; It can also be used to disable animated images storage all together