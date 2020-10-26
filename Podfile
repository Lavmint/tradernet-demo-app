# Uncomment the next line to define a global platform for your project
require 'find'

platform :ios, '13.0'

install! 'cocoapods',
         :integrate_targets => false

target 'StockQuotes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for StockQuotes
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'

end

post_install do |installer|
  	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
  		generate_xcframework(target, "./StockQuotesLibrary/Frameworks")
  	end
end

def generate_xcframework(target, xcframework_path)

	if target.name.include? "Pods-"
		return
	end

	archive_root = "./Archive/#{target.name}"
	sdks = ["iphoneos", "iphonesimulator"]
	frameworks_args = ""

	sdks.each { |sdk|

		if path = framework_path(target, sdk)
			puts "Found #{target.name} for #{sdk}."
			frameworks_args += "-framework #{path} "
			next
		end

		archivePath = "#{archive_root}/#{sdk}"
		puts "Archiving #{target.name} for #{sdk}..."
		system("xcodebuild archive -quiet -project ./Pods/Pods.xcodeproj -scheme #{target.name} -sdk #{sdk} -parallelizeTargets -archivePath #{archivePath} SKIP_INSTALL=NO")

		if path = framework_path(target, sdk)
			frameworks_args += "-framework #{path} "
		end
	}

	puts frameworks_args
	system("xcodebuild -quiet -create-xcframework #{frameworks_args} -output #{xcframework_path}/#{target.name}.xcframework")

end

def framework_path(target, sdk)
	Find.find('.') do |path|
		if (path.include? target.name) && (path.include? sdk) && (path.include? ".framework")
			return path
		end
	end
	return nil
end
