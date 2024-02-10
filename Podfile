# Uncomment the next line to define a global platform for your project
 platform :ios, '14.3'

def core_lib
  pod 'R.swift'
  pod 'RxSwift', '~> 5.1'
  pod 'RxCocoa', '~> 5.1'
  pod 'RxDataSources', '~> 4'
  pod 'RxWKWebView'
end

def application_lib
  pod 'SnapKit'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher'
end

def network_lib
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'ObjectMapperAdditions/Core'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'GoogleSignIn'
end

def security_pods
  pod 'IOSSecuritySuite', '~> 1.9.6'
  pod 'TrustKit'
end

target 'TopValue' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TopValue
  core_lib
  application_lib
  network_lib
  security_pods
  
  target 'TopValueTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TopValueUITests' do
    # Pods for testing
  end

end

target 'TopValue-Staging' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for TopValue-Staging
  core_lib
  application_lib
  network_lib
  security_pods
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
