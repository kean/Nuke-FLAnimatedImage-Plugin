// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import UIKit
import ImageIO
import FLAnimatedImage
import Nuke

/// Represents animated image data alongside a poster image (first image frame).
public class AnimatedImage: UIImage {
    public let data: Data
    
    public init(data: Data, poster: CGImage) {
        self.data = data
        super.init(cgImage: poster, scale: 1, orientation: .up)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(forKey: "_nk_data") as? Data else {
            return nil
        }
        self.data = data
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(data, forKey: "_nk_data")
    }
    
    public required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }
}

public extension AnimatedImage {
    /// Default `Nuke.Manager` with animated GIF support.
    public static let manager: Nuke.Manager = {
        // Make a decoder which supports animated GIFs.
        let decoder = Nuke.DataDecoderComposition(decoders: [AnimatedImageDecoder(), Nuke.DataDecoder()])
        
        // Updates `Cache` cost calculation block.
        let cache = Nuke.Cache().preparedForAnimatedImages()

        var options = Loader.Options()
        // Disable processing of animated images.
        options.processor = { image, request in
            return image is AnimatedImage ? nil : request.processor
        }

        let loader = Nuke.Loader(loader: Nuke.DataLoader(), decoder: decoder, options: options)
        return Manager(loader: loader, cache: cache)
    }()
}

/// Creates instances of `AnimatedImage` class from the given data.
/// Returns `nil` is data doesn't contain an animated GIF.
public class AnimatedImageDecoder: Nuke.DataDecoding {
    public init() {}
    
    public func decode(data: Data, response: URLResponse) -> Nuke.Image? {
        guard self.isAnimatedGIFData(data) else {
            return nil
        }
        guard let poster = self.posterImage(for: data) else {
            return nil
        }
        return AnimatedImage(data: data, poster: poster)
    }
    
    public func isAnimatedGIFData(_ data: Data) -> Bool {
        let sigLength = 3
        if data.count < sigLength {
            return false
        }
        var sig = [UInt8](repeating: 0, count: sigLength)
        (data as NSData).getBytes(&sig, length:sigLength)
        return sig[0] == 0x47 && sig[1] == 0x49 && sig[2] == 0x46
    }
    
    private func posterImage(for data: Data) -> CGImage? {
        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
            return CGImageSourceCreateImageAtIndex(source, 0, nil)
        }
        return nil
    }
}

/// Simple `FLAnimatedImage` wrapper that implement `Nuke.Target` protocol.
///
/// The reason why this is a standalone class and not a simple overridden method
/// from `UIImageView` extension is because declarations from extensions
/// cannot be overridden in Swift (yet).
public class AnimatedImageView: UIView, Nuke.Target {
    public let imageView: FLAnimatedImageView
    
    public init(imageView: FLAnimatedImageView = FLAnimatedImageView()) {
        self.imageView = imageView
        
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
        
        layoutMargins = UIEdgeInsets.zero
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        for attr in [.top, .leading, .bottom, .trailing] as [NSLayoutAttribute] {
            addConstraint(NSLayoutConstraint(item: imageView, attribute: attr, relatedBy: .equal, toItem: self, attribute: attr, multiplier: 1, constant: 0))
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("AnimatedImageView doesn't support NSCoding yet")
    }
    
    /// Displays an image on success. Runs `opacity` transition if
    /// the response was not from the memory cache.
    public func handle(response: Result<Image>, isFromMemoryCache: Bool) {
        guard let image = response.value else { return }
        imageView.nk_display(image)
        if !isFromMemoryCache {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 0.25
            animation.fromValue = 0
            animation.toValue = 1
            let layer: CALayer? = imageView.layer // Make compiler happy on OSX
            layer?.add(animation, forKey: "imageTransition")
        }
    }
}


public extension FLAnimatedImageView {
    /// Displays a given image. Starts animation if image is an instance of AnimatedImage.
    public func nk_display(_ image: Image?) {
        guard image != nil else {
            self.animatedImage = nil
            self.image = nil
            return
        }
        if let image = image as? AnimatedImage {
            // Display poster image immediately
            self.image = image
            
            // Prepare FLAnimatedImage object asynchronously (it takes a
            // noticeable amount of time), and start playback.
            DispatchQueue.global().async {
                let animatedImage = FLAnimatedImage(animatedGIFData: image.data)
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

public extension Nuke.Cache {
    /// Updates `Cache` cost block by adding special handling of `AnimatedImage`.
    public func preparedForAnimatedImages() -> Self {
        let cost = self.cost
        self.cost = {
            var val = cost($0)
            if let animatedImage = $0 as? AnimatedImage {
                val += animatedImage.data.count
            }
            return val
        }
        return self
    }
}
