Pod::Spec.new do |s|
  s.name          = "MKKit"
  s.version       = "0.0.1"
  s.summary       = "MK tool kit."
  s.description   = <<-DESC
                    DESC
  s.homepage      = "https://github.com/mk2016/MKKit"
  s.license       = "MIT"
  s.author             = { "MK Xiao" => "xiaomk7758@sina.com" }
  s.social_media_url   = "https://mk2016.github.io"
  s.platform      = :ios, "8.0"
  s.source        = { :git => "", :tag => "#{s.version}" }
  s.source_files  = "MKKit/**/*.{h,m}"
end
