// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk (github.com/kean).

import Foundation
#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

import Nuke

public class AnimatedImageLoaderDelegate: ImageLoaderDelegate {
    public init() {}
    
    public func imageLoader(loader: ImageLoader, shouldProcessImage image: Image) -> Bool {
        return !(image is AnimatedImage)
    }
}
