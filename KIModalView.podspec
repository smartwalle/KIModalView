Pod::Spec.new do |s|
  s.name         = "KIModalView"
  s.version      = "0.0.1"
  s.summary      = "KIModalView"
  s.description  = <<-DESC
                  KIModalView.
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIModalView"
  s.license      = "MIT"
  s.author             = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/smartwalle/KIModalView.git", :tag => "#{s.version}" }
  s.source_files = "KIModalView/KIModalView/*.{h,m}"
  s.requires_arc = true
end
