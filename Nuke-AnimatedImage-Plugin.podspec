Pod::Spec.new do |s|
    s.name             = "Nuke-AnimatedImage-Plugin"
    s.version          = "0.5.0"
    s.summary          = "Animated image plugin for Nuke - image managing framework"

    s.homepage         = "https://github.com/kean/Nuke-AnimatedImage-Plugin"
    s.license          = "MIT"
    s.author           = "Alexander Grebenyuk"
    s.source           = { :git => "https://github.com/kean/Nuke-AnimatedImage-Plugin.git", :tag => s.version.to_s }
    s.social_media_url = "https://twitter.com/a_grebenyuk"

    s.module_name      = "NukeAnimatedImagePlugin"

    s.ios.deployment_target = "8.0"

    s.dependency "Nuke", "~> 3.0"
    s.dependency "FLAnimatedImage", "~> 1.0"

    s.source_files  = "Source/**/*"
end
