Pod::Spec.new do |s|
  s.name             = "DLS-SWAPIServices"
  s.version          = "0.2.13"
  s.summary          = "Set of classes to provide iOS app access to SW GP Services API"
  s.description      = <<-DESC
                    This pod provide access to SW GP Services API and
                    IDP authentication server.
                       DESC

  s.homepage         = "https://github.com/alex-rudyak-dls/DLS-SWAPIServices"
  s.license          = 'MIT'
  s.author           = { "Alex Rudyak" => "aliaksandr.rudziak@digitallifesciences.co.uk" }
  s.source           = { :git => "https://github.com/alex-rudyak-dls/DLS-SWAPIServices.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'Foundation'
  s.dependency 'Realm', '0.96.3'
  s.dependency 'AFNetworking', '~> 2'
  s.dependency 'CocoaLumberjack', '~> 2.2.0'
  s.dependency 'PromiseKit', '~> 1.7.6'
  s.dependency 'EasyMapping', '0.15.4'
  s.dependency 'Underscore.m', '0.2.1'
  s.dependency 'NSDate-Escort', '1.5.3'
  s.dependency 'ITDispatchManagement', '0.1.0'
end
