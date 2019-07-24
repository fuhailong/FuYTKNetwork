#
# Be sure to run `pod lib lint FuYTKNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FuYTKNetwork'
  s.version          = '0.1.0'
  s.summary          = '对YTKNetwork进行了封装，方便新工程快速继承网络模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
对YTKNetwork进行了封装，可以使用Http/FuHttpStatement来声明所有接口，以及对应的model，还有网络配置，baseUrl及https证书，使用Http/FuHttpApi来声明所有请求方法，使用HttpTools/FuBaseApi来配置请求头，缓存时间，以及逻辑上的方法解析,如果在声明时没有对应的Model,会提示需要添加的Model内容，但目前还不完善，例如model->list->object，这样最后的object没有解析
                       DESC

  s.homepage         = 'https://github.com/fuhailong/FuYTKNetwork.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Fu Hailong' => '165255032@qq.com' }
  s.source           = { :git => 'https://github.com/fuhailong/FuYTKNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FuYTKNetwork/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'FuYTKNetwork' => ['FuYTKNetwork/Assets/*.png']
  # }

  #s.public_header_files = 'FuYTKNetwork/**/*.{h}'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency "AFNetworking", "~> 3.2.1" 
  s.dependency 'YTKNetwork', '~> 2.0.4'
  s.dependency 'YYKit', '~> 1.0.9'
  s.dependency 'ReactiveObjC', '~> 3.1.1'
end
