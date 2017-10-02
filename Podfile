# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'MVVMApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    pod 'Alamofire'
    pod 'AlamofireReactiveExtensions', '2.1.0-alpha.2'

	pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'

    pod 'ReactiveCocoa', '6.1.0-alpha.2'
    pod 'ReactiveSwift', '2.1.0-alpha.2'
    pod 'Swinject'

    # Pods for MVVMApp

    target 'MVVMAppTests' do
        inherit! :search_paths
        # Pods for testing

        pod 'Quick'
        pod 'Nimble'
    end

end

target 'MVVMAppModels' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    pod 'Alamofire'
    pod 'AlamofireReactiveExtensions', '2.1.0-alpha.2'
	pod 'ReactiveCocoa', '6.1.0-alpha.2'
	pod 'ReactiveSwift', '2.1.0-alpha.2'

    # Pods for MVVMAppModels

    target 'MVVMAppModelsTests' do
        inherit! :search_paths
        # Pods for testing

        pod 'Quick'
        pod 'Nimble'
    end

end

target 'MVVMAppViewModels' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

	pod 'ReactiveCocoa', '6.1.0-alpha.2'
	pod 'ReactiveSwift', '2.1.0-alpha.2'

    # Pods for MVVMAppViewModels

    target 'MVVMAppViewModelsTests' do
        inherit! :search_paths
        # Pods for testing

        pod 'Quick'
        pod 'Nimble'
    end

end

target 'MVVMAppViews' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

	pod 'ReactiveCocoa', '6.1.0-alpha.2'
	pod 'ReactiveSwift', '2.1.0-alpha.2'

    # Pods for MVVMAppViews

    target 'MVVMAppViewsTests' do
      inherit! :search_paths
      # Pods for testing

      pod 'Quick'
      pod 'Nimble'
    end

end


post_install do |installer|
	installer.pods_project.targets.each do |target|
		if target.name == 'ReactiveCocoa'
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '3.0'
			end
		end
	end
end
