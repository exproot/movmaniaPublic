platform :ios, '14.7'

target 'VBMovmania' do
  use_frameworks!

	pod 'SDWebImage'
  	pod 'youtube-ios-player-helper'
  	pod 'FirebaseCore'
 	pod 'FirebaseAuth'
	pod 'FirebaseFirestore'
	pod 'FirebaseStorage'
	pod 'lottie-ios'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end