Pod::Spec.new do |s|

  s.name          = 'ANShareKit'
  s.version       = '1.0.4'
  s.summary       = 'Sharing feature to Wechat, SinaWeibo, Tencent'
  s.homepage      = 'https://github.com/candyan/ANShareKit'
  s.license       = 'MIT'
  s.author        = { 'Candyan' => 'liuyanhp@gmail.com' }
  s.platform      = :ios, '6.0'
  s.source        = {
      :git => 'https://github.com/candyan/ANShareKit.git',
      :tag => s.version.to_s
  }

  s.subspec 'Core' do |core|
    core.source_files  = 'Classes/*.{h,m}'
    core.resources     = 'Resources/ANShareKit.xcassets'
    core.libraries     = 'sqlite3', 'z', 'c++'
    core.frameworks    = 'SystemConfiguration', 'CoreTelephony'
    core.dependency    'Masonry'
    core.dependency    'FXBlurView'
    core.requires_arc  = true
  end

  s.subspec 'Weixin' do |wxs|
    wxs.source_files  = 'Classes/Category/Weixin/*.{h,m}'
    wxs.dependency 'WeixinSDK',         '~>1.4.3'
    wxs.xcconfig = {"GCC_PREPROCESSOR_DEFINITIONS" => 'AN_WEIXIN_SHARE=1'}
    wxs.dependency 'ANShareKit/Core'
  end

  s.subspec 'SinaWeibo' do |swbs|
    swbs.source_files  = 'Classes/Category/SinaWeibo/*.{h,m}'
    swbs.dependency 'WeiboSDK',             '~>3.1.3'
    swbs.xcconfig = {"GCC_PREPROCESSOR_DEFINITIONS" => 'AN_SINAWB_SHARE=1'}
    swbs.dependency 'ANShareKit/Core'
  end

  s.subspec 'Tencent' do |ts|
    ts.source_files  = 'Classes/Category/Tencent/*.{h,m}'
    ts.dependency 'TencentOpenApiSDK',    '~> 2.9'
    ts.xcconfig = {"GCC_PREPROCESSOR_DEFINITIONS" => 'AN_TENCENT_SHARE=1'}
    ts.dependency 'ANShareKit/Core'
    ts.frameworks   = 'TencentOpenAPI'
  end

  s.subspec 'Tencent-32bit' do |ts32|
    ts32.source_files  = 'Classes/Category/Tencent/*.{h,m}'
    ts32.dependency 'TencentOpenApiSDK/32bit',    '~> 2.3.1.1'
    ts32.xcconfig = {"GCC_PREPROCESSOR_DEFINITIONS" => 'AN_TENCENT_SHARE=1'}
    ts32.dependency 'ANShareKit/Core'
    ts32.frameworks   = 'TencentOpenAPI'
  end

  s.default_subspec = 'Weixin', 'SinaWeibo', 'Tencent'

end
