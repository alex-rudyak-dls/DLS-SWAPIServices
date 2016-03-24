#
# Be sure to run `pod lib lint DLS-SWAPIServices.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DLS-SWAPIServices"
  s.version          = "0.2.12"
  s.summary          = "Set of classes to provide iOS app access to SW GP Services API"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                    This pod provide access to SW GP Services API and
                    IDP authentication server.
                       DESC

  s.homepage         = "https://github.com/alex-rudyak-dls/DLS-SWAPIServices"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alex Rudyak" => "aliaksandr.rudziak@digitallifesciences.co.uk" }
  s.source           = { :git => "https://github.com/alex-rudyak-dls/DLS-SWAPIServices.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DLS-SWAPIServices' => ['Pod/Assets/*.png']
  }

# s.public_header_files = 'Pod/Classes/Headers/*.h'
    s.frameworks = 'Foundation'
    s.dependency 'Realm', '0.96.3'
    s.dependency 'AFNetworking', '~> 2'
    s.dependency 'CocoaLumberjack', '~> 2.2.0'
    s.dependency 'EasyMapping', '0.15.4'
    s.dependency 'Underscore.m', '0.2.1'
    s.dependency 'NSDate-Escort', '1.5.3'
    s.dependency 'ITDispatchManagement', '0.1.0'
    s.dependency 'Bolts/Tasks', '~> 1.6'
end
