// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import UIKit
import FLAnimatedImage
import Nuke
import ImageIO

public class AnimatedImage: UIImage {
    public let data: NSData! // it's nonnull
    
    public init(data: NSData, poster: CGImageRef) {
        self.data = data
        super.init(CGImage: poster, scale: 1, orientation: .Up)
    }
    
    public required init?(coder decoder: NSCoder) {
        self.data = nil // makes me sad
        super.init(coder: decoder)
    }
    
    public required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }
}

/** Creates instances of `AnimatedImage` class from the given data. Checks if the image data is in a GIF image format, otherwise returns nil.
 */
public class AnimatedImageDecoder: ImageDecoding {
    public init() {}
    
    public func decode(data: NSData, response: NSURLResponse?) -> Image? {
        guard self.isAnimatedGIFData(data) else {
            return nil
        }
        guard let poster = self.posterImageFor(data) else {
            return nil
        }
        return AnimatedImage(data: data, poster: poster)
    }
    
    public func isAnimatedGIFData(data: NSData) -> Bool {
        let sigLength = 3
        if data.length < sigLength {
            return false
        }
        var sig = [UInt8](count: sigLength, repeatedValue: 0)
        data.getBytes(&sig, length:sigLength)
        return sig[0] == 0x47 && sig[1] == 0x49 && sig[2] == 0x46
    }
    
    private func posterImageFor(data: NSData) -> CGImageRef? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return CGImageSourceCreateImageAtIndex(source, 0, nil)
        }
        return nil
    }
    
}

/** Extension that adds image loading capabilities to the FLAnimatedImageView.
 */
public extension FLAnimatedImageView {
    /// Displays a given image. Starts animation if image is an instance of AnimatedImage.
    public func nk_displayImage(image: Image?) {
        guard image != nil else {
            self.animatedImage = nil
            self.image = nil
            return
        }
        if let image = image as? AnimatedImage {
            // Display poster image immediately
            self.image = image

            // Start playback after we prefare FLAnimatedImage for rendering
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let animatedImage = FLAnimatedImage(animatedGIFData: image.data)
                dispatch_async(dispatch_get_main_queue()) {
                    if self.image === image { // Still displaying the same poster image
                        self.animatedImage = animatedImage
                    }
                }
            }
        } else {
            self.image = image
        }
    }
}

/** Prevents `ImageLoader` from processing animated images.
 */
public class AnimatedImageLoaderDelegate: ImageLoaderDefaultDelegate {
    public override func loader(loader: ImageLoader, processorFor request: ImageRequest, image: Image) -> ImageProcessing? {
        return image is AnimatedImage ? nil : super.loader(loader, processorFor: request, image: image)
    }
}

/** Memory cache that is aware of animated images. Can be used for both single-frame and animated images.
 */
public class AnimatedImageMemoryCache: ImageMemoryCache {

    /** Can be used to disable storing animated images. Default value is true (storage is allowed).
     */
    public var allowsAnimatedImagesStorage = true

    public override func setResponse(response: ImageCachedResponse, forKey key: ImageRequestKey) {
        if !self.allowsAnimatedImagesStorage && response.image is AnimatedImage {
            return
        }
        super.setResponse(response, forKey: key)
    }

    public override func costFor(image: Image) -> Int {
        if let animatedImage = image as? AnimatedImage {
            return animatedImage.data.length + super.costFor(image)
        }
        return super.costFor(image)
    }
}
