Pod::Spec.new do |s|
  s.name             = 'NOVAppReview'
  s.version          = '0.1.1'
  s.summary          = 'A short description of NOVAppReview.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.com/novapps/ios-app/framework/novappreview'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangyu' => 'yangyu2010@aliyun.com' }
  s.source           = { :git => 'https://gitlab.com/novapps/ios-app/framework/novappreview.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'NOVAppReview/Classes/**/*'
  s.swift_versions = ['5.0', '5.1']
  s.dependency 'NOVRemoteConfig'
    
end
