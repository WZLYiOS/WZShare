Pod::Spec.new do |s|
  s.name             = 'WZShareKit'
  s.version          = '2.1.0'
  s.summary          = '我主良缘分享组件.'

  s.homepage         = 'https://github.com/WZLYiOS/WZShare'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuSky' => '327847390@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZShare.git', :tag => s.version.to_s }


  s.requires_arc = true
  s.static_framework = true
  s.swift_version         = '5.0'
  s.ios.deployment_target = '9.0'
  s.default_subspec = 'Source'
  
  s.subspec 'Source' do |ss|
    ss.source_files = 'WZShareKit/Classes/SDK/*.swift'
  end

  s.subspec 'Binary' do |ss|
    ss.vendored_frameworks = "Carthage/Build/iOS/Static/WZShareKit.framework"
    ss.user_target_xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)' }
  end
end
