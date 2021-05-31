// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NukeFLAnimatedImagePlugin",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "NukeFLAnimatedImagePlugin", targets: ["NukeFLAnimatedImagePlugin"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/kean/Nuke.git",
            from: "10.0.0"
        ),
        .package(
            url: "https://github.com/Flipboard/FLAnimatedImage",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(name: "NukeFLAnimatedImagePlugin", dependencies: ["Nuke", "FLAnimatedImage"], path: "Source")
    ]
)
