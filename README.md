# watchtips

## Update Jul 2022
As there has been no development on the codebase, and hence no app release for some time(this was really a POC). The app in the iOS app store has been withdrawn from sale by Apple.

## Update Version 2.2
The Watch tips project has been updated again, The interface has been tidied up and a seperate value for the *tip* cost has been added and displayed ( a requested update).
I have also added a custom 'keypad' rather than using the standard one available for the platform, hopefully the app now looks a bit better than it did -  UX/UI design is not my strong point. 

But the biggest update is that there is now also an Android version (without Watch support). Doing this has helped a lot as I can use the Flutter Android app for development purposes so that I now have Hot Reload back (development is **good** again ....)

For iOS, I still need to run/build (and fail) with the Flutter tools for iOS (this is required to generate the correct build scripts) and finish with XCode, but general dev is know easier.

## Overview
This was an originally experiment to see if  can use Flutter to build an iOS app with an accompanying watchOS app. My first attempts using the beta product were not successful so the idea was parked. Having now re-visited this I can now get a compiled blank watch app up and running with a Flutter app, so I will, in stages, try and re-create the WatchTips app using Flutter.

If you interested in the original Titanium version is [here](https://github.com/magnatronus/Watch-Tips)


![Watch App](/screenshots/watchtips.png?raw=true "Watch and Phone App")


## App Store Link
Ths app is a *really simple* app and originally just created as a proof point.  

But for anyone interested here are the release links:

- [AppStore Link to Watch Tips](https://itunes.apple.com/us/app/watch-tips/id1205407902).
- [Playstore Link](https://play.google.com/store/apps/details?id=uk.spiralarm.tipcalculator).


## Plan

- *1.0* Create a vanilla Flutter app (this initial commit)
- *1.1* Add a blank watch project and get it working
- *1.2* Modify the watch app functionally into WatchTips
- *1.3* Update the Flutter app to WatchTips
- *1.4* See if I can bridge between the 2 app (as the Titanium version does)
- *2.0* Tidy up both the Flutter code and the iOS project and use it to submit the app into the App Store
- *2.x+* - updates and improvements 


## Flutter Package Project
From the results of this test project, I have started developing a Flutter Package to allow communication between a Flutter iOS app and a watch app. This should allow easier integration with some standard functionality, though it is still a pain ATM as after you add a Watch Kit target to the iOS project as Flutter run/build no longer works. This means all package testing and development then needs to be done via XCode. 

I have got messaging working from an iOS app to the watch via the plugin, this can be seen working in a[video here](https://butterfly-mobile.uk/flutter-and-apple-watch).





## Generating a Distro build
The only way, so far, I have found of creating a distro build is following this seqence.

### Set the Bundle ID
BEFORE adding the Watch Kit app target set the final bundle ID, as the Watch app and associated extension needs to use the same prefix. If not you may need to update all references BEFORE creating the final Archive.

### Change ALL the Version and Build values
This **MUST** be done for each target (in this case 3), change them to **$(FLUTTER_BUILD_NAME)**  and **$(FLUTTER_BUILD_NUMBER)** respectively, otherwise although the test runs work, the Archive will not unless the version numbers match.

### Run the Flutter build first
This will fail, but it generates the *correct shell scripts* to enable iOS to carry out the build (*flutter build ios --release*).

### Create Archive in XCode
- 1 Select Generic Device + watchOS Device as the destination
- 2 Run Product -> Archive
- 3 If build successful , run the Validate App
- 4 If validate successful - upload to App Store!!!



## Versions

### 2.1
- updated Watch and Phone UI
- currency now defaults to the phone/ipad locale
- package made universal, so it runs on iPad (no watch supoort)

### 2.0 
- first app store release

### 1.4 - Rough and Ready but Working!
I have now managed to add the required code into the iOS project to allow it to communicate with Flutter and send data updates from the watch so they are reflected in the app.
Basically if you do a calculation for a Tip on the watch then the data is transferred to the associated device.

You need to forgive the (bad?) Objective C coding as it is not really my thing  - who in their right mind thought of it in the first place anyway :-) . A lot of this was just brute force trial and error as well as a lot of searching and testing. 

Apart from that the difficult issue for me was that although **MethodChannel** is quite well documented, **EventChannel** is not, the only examples I found were to do with Plugin extensions, but again probably due to my dislike (due to not understanding it very well) of Objective C.

I will try to create a generic plug-in later, but that will be done in Swift.


### 1.3
So after a bit of a hair pulling out session I have managed to get this working. I now have a iWatch app as well as a Flutter iOS app to build and run. I have tested this by building and distribuing to a physical phone via HockeyApp. Now the bad news......

I cannot use Flutter to either build the Flutter project or do the iOS release build, so I actually built the Flutter app in a seperate project then added the lib dir back into this one.
This is a major pain as to do an testing, on device or simulator I need to use XCode to do all the build (i.e. no hot-reloading), but it does work.

To create the AD-HOC distro of the app I again used XCode, set the target to Generic Device and Archived the project. The resulting AD-OC signed app works well.

But I think the last stage will be a major hurdle as I WILL need to do all building  using XCode.........


### 1.2
Updated Watch app and added functioning WatchTips. Watch app can now be used to calculate Bill split and tips.

### 1.1
After using XCode to define a simulator with an attached Watch Emulator the standard Vanilla app (from 1.0) was updated as follows

- Set a bundle id on the iOS Runner app (u.spiralarm.watchtips)
- Add a new Target in XCode (File->New->Target), a WatchKit app was selected
- Untick *Include Notification Scene* and *Include Complication*
- Name the product *WatchTips*
- Generate 2 sets of assets (I use an app called **Asset Catalog Creator**), one for the Runner app and one for the Watch App so that both have a full set of icons.
- Open the interface.storyboard for rhe WatchTips app and add a button to the screen

After this I can no longer user the IDE (VSC) to start the app up in debug mode as I get the following error ( perhaps some sort of cusom build configuration is required):

```
=== BUILD TARGET WatchTips Extension OF PROJECT Runner WITH CONFIGURATION Debug ===
target specifies product type 'com.apple.product-type.watchkit2-extension', but there's no such product type for the 'iphonesimulator' platform
Could not build the application for the simulator.
Error launching application on iPhone 7 with Watch 42mm.
```

However, if I use XCode  I can use XCode to compile the app and run the watch app on the emulator.



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
