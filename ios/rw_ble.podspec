Pod::Spec.new do |s|
  s.name             = 'rw_ble'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for DHBleSDK'
  s.description      = 'Flutter plugin for real-time health features'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'email@example.com' }
  s.source           = { :path => '.' }

  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'

  # ✅ THIS MUST MATCH EXACTLY
  s.vendored_frameworks = 'Frameworks/DHBleSDK.framework'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
