# watchtips

This is an experiment to see if  can use Flutter to build an iOS app with an accompanying watchOS app. My first attempts using the beta product were not successful so the idea was parked.
Having now re-visited this I can now get a compiled blank watch app up and running with a Flutter app, so I will, in stages, try and re-create the WatchTips app using Flutter.

My plan is to:

- *1.0* Create a vanilla Flutter app (this initial commit)
- *1.1* Add a blank watch project and get it working
- *1.2* Modify the watch app functionally into WatchTips
- *1.3* Update the Flutter app to WatchTips
- *1.4* See if I can bridge between the 2 app (as the Titanium version does)


## Versions

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





[Titanium version is here](https://github.com/magnatronus/Watch-Tips)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
