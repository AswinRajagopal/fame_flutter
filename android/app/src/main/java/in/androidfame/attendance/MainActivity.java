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
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends FlutterActivity {

  private Intent forService;

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
              startService();
              Timer timer = new Timer();
              timer.schedule(
                new TimerTask() {
                  @Override
                  public void run() {
                    //what you want to do
                  }
                },
                0,
                10000
              ); //wait 0 ms before doing the action and do it evry 1000ms (1second)

              timer.cancel(); //stop the timer
              result.success("Service Started");
            }
          }
        }
      );
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
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
