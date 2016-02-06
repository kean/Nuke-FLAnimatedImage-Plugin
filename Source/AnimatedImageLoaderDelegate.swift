// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import Foundation
#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

import Nuke

public class AnimatedImageLoaderDelegate: ImageLoaderDefaultDelegate {
    public override func loader(loader: ImageLoader, processorFor request: ImageRequest, image: Image) -> ImageProcessing? {
        return image is AnimatedImage ? nil : super.loader(loader, processorFor: request, image: image)
    }
}
