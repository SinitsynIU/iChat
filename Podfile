# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iChat
  pod 'Firebase/Core'
  pod 'FirebaseUI/Auth'
  pod 'FirebaseFirestore'
  pod 'GoogleSignIn'
  pod 'Firebase/Storage'
  pod 'SDWebImage'
  pod 'MessageKit'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
