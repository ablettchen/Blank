#
# Be sure to run `pod lib lint Blank.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Blank'
  s.version          = '0.1.6'
  s.summary          = 'blank view config.'
  s.homepage         = 'https://github.com/ablettchen/Blank'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ablett' => 'ablettchen@gmail.com' }
  s.source           = { :git => 'https://github.com/ablettchen/Blank.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ablettchen'
  
  s.ios.deployment_target = '8.0'
  s.swift_versions = '4.0'
  
  s.source_files = 'Blank/Classes/**/*'
  s.resource_bundles = {
     'Blank' => ['Blank/Assets/*.xcassets']
  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  s.dependency 'SnapKit'
  
end
