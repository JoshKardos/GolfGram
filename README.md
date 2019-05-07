# TuTour

TuTour is an iOS social networking application for students to find peer tutoring efficiently. Tools used for this project include Swift 4, Xcode, Firebase, and Cocoapods.

Alan Boo
Josh Kardos
Philip Nguyen
Gideon Ubaldo

## Cocoapods
Navigate to project folder
```bash
	pod init
	open -a Xcode Podfile
```
Add these pods to the podfile
```podfile
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'ProgressHUD'
pod 'TextFieldEffects'
pod 'PagingKit'
pod 'TaggerKit'
```
```bash
	pod install
```

