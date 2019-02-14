package com.example.watchtips;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.content.res.Resources;
import android.os.LocaleList;
import 	java.util.*;


public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), "uk.spiralarm.watchtips/tipinfo").setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          if (call.method.equals("preferredLanguages")) {
            result.success(getPreferredLanguages());
          } else {
            result.notImplemented();
          }
       }
    });
  }

  private List<String> getPreferredLanguages() {
    LocaleList list = Resources.getSystem().getConfiguration().getLocales().getAdjustedDefault();
    List<String> result = new ArrayList<String>();
    for(int i=0; i<list.size(); i++){
      result.add(list.get(i).toString());
    }
    return result;
  }
  
}
