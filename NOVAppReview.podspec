Pod::Spec.new do |s|
  s.name             = 'NOVAppReview'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NOVAppReview.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangyu/NOVAppReview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangyu' => 'yangyu2010@aliyun.com' }
  s.source           = { :git => 'https://github.com/yangyu/NOVAppReview.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'NOVAppReview/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NOVAppReview' => ['NOVAppReview/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.swift_versions = ['5.0', '5.1']


  s.dependency 'NOVRemoteConfig'
    
end
