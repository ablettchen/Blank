#
# Be sure to run `pod lib lint Blank.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Blank'
  s.version          = '0.1.2'
  s.summary          = 'blank view config.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/ablettchen/Blank'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ablett' => 'ablettchen@gmail.com' }
  s.source           = { :git => 'https://github.com/ablettchen/Blank.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ablettchen'

  s.ios.deployment_target = '8.0'
#  s.ios.swift.version = '4.0'
  
  s.source_files = 'Blank/Classes/**/*' 
  
  s.resource_bundles = {
     'Blank' => ['Blank/Assets/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
  
end
