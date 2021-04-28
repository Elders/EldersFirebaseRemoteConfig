Pod::Spec.new do |s|

  s.name         = "EldersFirebaseRemoteConfig"
  s.version      = "1.1.1"
  s.source       = { :git => "https://github.com/Elders/#{s.name}.git", :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Milen Halachev"
  s.summary      = "Convenience Firebase Remote Config + Combine + SwiftUI"
  s.homepage     = "https://github.com/Elders/#{s.name}"

  s.swift_version = "5.4"
  s.ios.deployment_target = "9.0"

  s.source_files  = "#{s.name}/**/*.swift", "#{s.name}/**/*.{h,m}"
  s.public_header_files = "#{s.name}/**/*.h"
  s.exclude_files = "#{s.name}/scripts/**/*.swift"
  s.preserve_paths = "#{s.name}/scripts"
  
  s.static_framework = true

  s.dependency 'FirebaseRemoteConfig'
  
end
