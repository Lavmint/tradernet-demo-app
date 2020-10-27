# Uncomment the next line to define a global platform for your project
require 'find'

platform :ios, '13.0'

install! 'cocoapods', :integrate_targets => false

target 'StockQuotes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for StockQuotes
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'

end

post_install do |installer|
	xcarchive_path = "./PodsArchive"
	xcframework_path = "./StockQuotesLibrary"
  	installer.pods_project.targets.each do |target|
  		generate_xcframework(target, sdk("ios"), xcarchive_path, xcframework_path, installer.update)
  	end
end

def sdk(platform)
	if platform == "mac"
		return ["macosx"]
	end
	if platform == "ios"
		return ["iphoneos", "iphonesimulator"]
	end
	if platform == "tv"
		return ["appletvos", "appletvsimulator"]
	end
	if platform == "watch"
		return ["watchos", "watchsimulator"]
	end
	if platform == "driver"
		return ["driverkit.macosx"]
	end
	return []
end 

def generate_xcframework(target, sdks, xcarchive_path, xcframework_path, clean_up)

	if sdks.length == 0
		return
	end

	if target.name.include? "Pods-"
		return
	end

	if clean_up
		puts "Cleaning #{xcarchive_path} and *.xcframework in #{xcframework_path}"
		system("rm -rf #{xcarchive_path} #{xcframework_path}/*.xcframework")
	end

	target.build_configurations.each do |config|
	    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end

	frameworks_args = ""
	sdks.each { |sdk|

		archive_path = "#{xcarchive_path}/#{target.name}-#{sdk}.xcarchive"

		if path = find(target.name, sdk)
			puts "Found #{target.name} for #{sdk}: #{path}"
			frameworks_args += "-framework #{path} "
			next
		end

		puts "Building #{target.name} for #{sdk}..."
		# system("xcodebuild archive -quiet -project ./Pods/Pods.xcodeproj -scheme #{target.name} -sdk #{sdk} -parallelizeTargets -archivePath #{archive_path} SKIP_INSTALL=NO")

		if path = find(target.name, sdk)
			frameworks_args += "-framework #{path} "
		else
			puts "Failed to found #{target.name} for #{sdk} after build"
		end
	}

	framework_path = "#{xcframework_path}/#{target.name}.xcframework"
	puts "Creating xcframework for #{target.name}..."
	system("rm -rf #{framework_path}")
	system("xcodebuild -quiet -create-xcframework #{frameworks_args} -output #{framework_path}")
	system("rm -rf build")
end

def find(target_name, sdk)
	Find.find('.') do |path|
		if (path.include? target_name) && (path.include? sdk) && (path.include? ".framework")
			return path
		end
	end
	return nil
end