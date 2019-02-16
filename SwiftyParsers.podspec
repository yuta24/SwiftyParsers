Pod::Spec.new do |spec|
  spec.name         = "SwiftyParsers"
  spec.version      = "0.0.1"
  spec.summary      = " parser combinators written by Swift."
  spec.homepage     = "https://github.com/yuta24/SwiftyParsers"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "yuta24" => "yuta24@bivre.com" }
  spec.social_media_url   = "https://twitter.com/yuta24"
  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/yuta24/SwiftyParsers", :tag => "#{spec.version}" }
  spec.source_files  = "Sources", "Sources/**/*.swift"
end
