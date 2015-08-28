#
# Be sure to run `pod lib lint Eddystone.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Eddystone"
  s.version          = "1.1.1"
  s.summary          = "Explore Eddystone and the Physical Web"
  s.description      = "Add Eddystone support to your app and start letting your users interact with Eddystone beacons and the Physical Web. This cocoapod will allow you to scan for Beacons broadcasting the Eddystone-URL, Eddystone-UID, and Eddystone-TLM protocol."
  s.homepage         = "https://github.com/BlueBiteLLC/Eddystone"
  s.license          = 'MIT'
  s.author           = { "Tanner Nelson" => "tanner@bluebite.com" }
  s.source           = { :git => "https://github.com/BlueBiteLLC/Eddystone.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BlueBite'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Eddystone' => ['Pod/Assets/*.png']
  }
  s.frameworks = 'CoreBluetooth'
end
