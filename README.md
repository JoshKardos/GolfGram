#TuTour

TuTour is an iOS application for studetns to find peer tutroing quickly.

##Cocoapods
Navigate to project folder
'''bash
	pod init
	open -a Xcode Podfile
'''
Add these pods to the podfile
'''swift
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'ProgressHUD'
'''
'''bash
	pod install
'''

