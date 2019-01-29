#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface WTUserInfoHandler : NSObject <FlutterStreamHandler>
@end

// Modified to add the Watch Session Delegate
@interface AppDelegate : FlutterAppDelegate <WCSessionDelegate>{
    @private
    WCSession *watchSession;
    WTUserInfoHandler* userInfoStreamHandler;
}
@end
