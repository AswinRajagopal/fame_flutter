package in.androidfame.attendance;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private Intent forService;
  MySharedPreference sharedPreference;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    super.configureFlutterEngine(flutterEngine);

    forService = new Intent(MainActivity.this, MyService.class);

    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      "in.androidfame.attendance"
    )
    .setMethodCallHandler(
        new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(
            MethodCall methodCall,
            MethodChannel.Result result
          ) {
            if (methodCall.method.equals("startService")) {
              Intent intent = new Intent(MainActivity.this, BackgroundService.class);
              sharedPreference.putPreferenceString
                      (MySharedPreference.COMPANY_ID,methodCall.argument("companyId"));
              sharedPreference.putPreferenceString
                      (MySharedPreference.USER_ID,methodCall.argument("empId"));
//              Bundle bundle = new Bundle();
//              bundle.putString("empId", methodCall.argument("empId"));
////              bundle.putString("trackingInterval", methodCall.argument("trackingInterval")+"");
//              bundle.putString("companyId", methodCall.argument("companyId"));
//              intent.putExtras(bundle);
              // startService();
              startService(intent);
              result.success("Service Started");
            }
            if (methodCall.method.equals("stopService")) {
              // startService();
              stopService(new Intent(MainActivity.this, BackgroundService.class));
              result.success("Service Stopped");
            }
          }
        }
      );
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    sharedPreference = new MySharedPreference(this);
    // GeneratedPluginRegistrant.registerWith(this);

  }

  // @Override
  // protected void onDestroy() {
  // super.onDestroy();
  // stopService(forService);
  // startService();
  // result.success("Service Started");
  // }

  private void startService() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      startForegroundService(forService);
    } else {
      startService(forService);
    }
  }
}
