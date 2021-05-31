// The MIT License (MIT)
//
// Copyright (c) 2016-2021 Alexander Grebenyuk (github.com/kean).

import UIKit
import FLAnimatedImage
import Nuke

extension FLAnimatedImageView {
    open override func nuke_display(image: UIImage?, data: Data?) {
        guard image != nil else {
            self.animatedImage = nil
            self.image = nil
            return
        }
        if let data = data {
            // Display poster image immediately
            self.image = image

            // Prepare FLAnimatedImage object asynchronously (it takes a
            // noticeable amount of time), and start playback.
            DispatchQueue.global().async {
                let animatedImage = FLAnimatedImage(animatedGIFData: data)
                DispatchQueue.main.async {
                    // If view is still displaying the same image
                    if self.image === image {
                        self.animatedImage = animatedImage
                    }
                }
            }
        } else {
            self.image = image
        }
    }
}
