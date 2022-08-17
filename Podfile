platform :ios, '13.0'

target 'JodelChallenge' do
  pod 'FlickrKit', '1.0.9'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
