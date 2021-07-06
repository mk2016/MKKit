Pod::Spec.new do |s|
  s.name              = "MKKit"
  s.version           = "0.0.1"
  s.summary           = "MK tool kit."
  s.homepage          = "https://github.com/mk2016/MKKit"
  s.license           = "MIT"
  s.author            = { "MK Xiao" => "xiaomk7758@sina.com" }
  s.social_media_url  = "https://mk2016.github.io"
  s.platform          = :ios, "9.0"
  s.source            = { :git => "", :tag => "#{s.version}" }
  s.source_files      = "MKKit/**/*.{h,m,xib}"
  s.resource          = "MKKit/**/*.{bundle}"
  s.requires_arc      = true
  s.dependency        "AFNetworking", '~> 4.0.1'
  s.dependency        "HappyDNS", '~> 0.3.15'
  s.dependency        "MJExtension", '~> 3.3.0'
  s.dependency        "Masonry", '~> 1.1.0'
  s.dependency        "SAMKeychain", '~> 1.5.3'
  s.dependency        "Toast", '~> 4.0.0'
  s.dependency        "MBProgressHUD", '~> 1.2.0'
end
