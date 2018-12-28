# GolfGram
Golfer's virtual paradise. Post awesome golf pictures and videos.


PODSFILE
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'GolfGram' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Pods for GolfGram

pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'ProgressHUD'


end
