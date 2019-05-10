# TuTour

TuTour is an iOS social networking application for students to find peer tutoring efficiently. Tools used for this project include Swift, Xcode, Firebase, and Cocoapods.

## Project Team
Alan Boo <br />
Josh Kardos <br />
Philip Nguyen <br />
Gideon Ubaldo <br />

## Versions
Swift: 4 <br />
Xcode: 10.2 <br />
Cocoapods: 1.5.3 <br />

## Getting Started - Cocoapods

Navigate to project folder in terminal
```bash
pod init
open -a Xcode Podfile
```
Add the following lines to the podfile
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

