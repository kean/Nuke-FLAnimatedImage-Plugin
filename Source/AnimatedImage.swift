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
    public override var nk_image: UIImage? {
        get {
            return self.image
        }
        set {
            guard newValue != nil else {
                self.animatedImage = nil
                self.image = nil
                return
            }
            if let image = newValue as? AnimatedImage {
                self.animatedImage = FLAnimatedImage(animatedGIFData: image.data)
            } else {
                self.image = newValue
            }
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
