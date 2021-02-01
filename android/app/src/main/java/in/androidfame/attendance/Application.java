package in.androidfame.attendance;

import android.os.Build;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class Application
  extends FlutterApplication
  implements PluginRegistrantCallback {

  @Override
  public void onCreate() {
    super.onCreate();
    FlutterFirebaseMessagingService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
    FlutterLocalNotificationsPlugin.registerWith(
      registry.registrarFor(
        "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"
      )
    );
  }
}
