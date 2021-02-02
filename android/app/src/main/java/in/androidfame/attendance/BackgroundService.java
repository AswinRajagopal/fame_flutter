package in.androidfame.attendance.service;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.BatteryManager;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;
import androidx.appcompat.app.AlertDialog;
import com.android.volley.VolleyError;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import in.androidfame.attendance.R;
import in.androidfame.attendance.layout.Utils;
import in.androidfame.attendance.network.MyVolley;
import in.androidfame.attendance.utility.DBAdapter;
import in.androidfame.attendance.utility.GPSTracker;
import in.androidfame.attendance.utility.MySharedPreference;
import in.androidfame.attendance.utility.UtilityFunctions;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class BackgroundService extends Service {

  private final LocationServiceBinder binder = new LocationServiceBinder();
  private final String TAG = "BackgroundService";
  private LocationListener mLocationListener;
  private LocationManager mLocationManager;
  private NotificationManager notificationManager;
  MySharedPreference sharedPreference;
  MyVolley myVolley;
  ArrayList<String> latlngarr = new ArrayList<>();
  DBAdapter db;
  LocationManager locationManager;

  private static int LOCATION_INTERVAL = 5;
  private final int LOCATION_DISTANCE = 0;
  FusedLocationProviderClient fusedLocationProviderClient;
  LocationCallback locationCallback;
  String battery_percent, current_date_time;

  @Override
  public IBinder onBind(Intent intent) {
    return binder;
  }

  private BroadcastReceiver mBatInfoReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context ctxt, Intent intent) {
      int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
      battery_percent = String.valueOf(level);

      System.out.println("batery_percent >>> " + battery_percent);
      Date today = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      String dateToStr = format.format(today);
      System.out.println("curent date time >>> " + dateToStr);
      current_date_time = dateToStr;
    }
  };

  @Override
  public int onStartCommand(Intent intent, int flags, int startId) {
    super.onStartCommand(intent, flags, startId);
    return START_STICKY;
  }

  @Override
  public void onCreate() {
    Log.i(TAG, "onCreate");
    //        Toast.makeText(getApplicationContext(), "Service start", Toast.LENGTH_SHORT).show();
    db = new DBAdapter(getApplicationContext());
    this.registerReceiver(
        this.mBatInfoReceiver,
        new IntentFilter(Intent.ACTION_BATTERY_CHANGED)
      );
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      startForeground(12345678, getNotification());
    }
    myVolley = new MyVolley(getApplicationContext());
    fusedLocationProviderClient =
      LocationServices.getFusedLocationProviderClient(getApplicationContext());
    sharedPreference = new MySharedPreference(getApplicationContext());
    LOCATION_INTERVAL =
      sharedPreference.getPreferenceInt(UtilityFunctions.TRACKINGINTERVAL);
    new LocationAsyncTask().execute();
  }

  @Override
  public void onDestroy() {
    super.onDestroy();
    if (mLocationManager != null) {
      try {
        mLocationManager.removeUpdates(mLocationListener);
      } catch (Exception ex) {
        Log.i(TAG, "fail to remove location listners, ignore", ex);
      }
    }
    //        startService(new Intent(getApplicationContext(), BackgroundService.class));
  }

  private void initializeLocationManager() {
    if (mLocationManager == null) {
      mLocationManager =
        (LocationManager) getApplicationContext()
          .getSystemService(Context.LOCATION_SERVICE);
    }
  }

  @SuppressLint("MissingPermission")
  public void startTracking() {
    LocationRequest locationRequest = LocationRequest.create();
    locationRequest.setPriority(
      LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
    );
    locationRequest.setInterval(600000);
    locationCallback =
      new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
          if (locationResult == null) {
            return;
          }
          for (Location location : locationResult.getLocations()) {
            if (location != null) {
              Log.d(
                "loc cb",
                "" + location.getLatitude() + " " + location.getLongitude()
              );
              update_location(
                location.getLatitude() + "",
                location.getLongitude() + ""
              );
              SimpleDateFormat sdf = new SimpleDateFormat(
                "HH",
                Locale.getDefault()
              );
              int currentDateandTime = Integer.parseInt(sdf.format(new Date()));
              if (currentDateandTime >= 21) {
                fusedLocationProviderClient.removeLocationUpdates(
                  locationCallback
                );
              }

              //                        ((DashboardActivity)getApplicationContext()).updatelocation();
              new LocationAsyncTask().execute();
            }
          }
        }
      };
    fusedLocationProviderClient.requestLocationUpdates(
      locationRequest,
      locationCallback,
      null
    );
  }

  private LocationListener getlocationListener() {
    LocationListener locationListener = new LocationListener() {
      @Override
      public void onLocationChanged(Location location) {
        Log.d("loc", "location changed");
        update_location(
          location.getLatitude() + "",
          location.getLongitude() + ""
        );
        mLocationManager.removeUpdates(mLocationListener);
      }

      @Override
      public void onStatusChanged(String s, int i, Bundle bundle) {
        Log.d("loc", "status changed");
      }

      @Override
      public void onProviderEnabled(String s) {
        Log.d("loc", "provider enabled");
      }

      @Override
      public void onProviderDisabled(String s) {
        Log.d("loc", "provider disabled");
      }
    };
    return locationListener;
  }

  public void stopTracking() {
    this.onDestroy();
  }

  private Notification getNotification() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel channel = new NotificationChannel(
        "channel1",
        "my channel",
        NotificationManager.IMPORTANCE_DEFAULT
      );
      NotificationManager notificationManager = getSystemService(
        NotificationManager.class
      );
      notificationManager.createNotificationChannel(channel);
      Notification.Builder builder = new Notification.Builder(
        getApplicationContext(),
        "channel1"
      )
        .setContentTitle("FaME is running in background")
        .setSmallIcon(R.drawable.ic_noti_icon);
      return builder.build();
    }
    return null;
  }

  public class LocationServiceBinder extends Binder {

    public BackgroundService getService() {
      return BackgroundService.this;
    }
  }

  public void update_location(String lat, String lng) {
    Map<String, String> request = new HashMap<>();
    request.put(
      "user_id",
      sharedPreference.getPreferenceString(MySharedPreference.USER_ID)
    );
    request.put("lat", lat);
    request.put("lng", lng);
    myVolley.FormRequest(
      UtilityFunctions.getBaseUrl() + "update_location.php",
      request,
      new MyVolley.stringCallback() {
        @Override
        public void onSuccess(String response) {
          UtilityFunctions.dismissLoadingDialog();
          if (response.equals("0")) {
            //                    Toast.makeText(getApplicationContext(), "Server error.", Toast.LENGTH_SHORT).show();
          }
        }

        @Override
        public void onFail(VolleyError error) {
          UtilityFunctions.dismissLoadingDialog();
        }
      }
    );
  }

  private void getcurrentlocation() {
    locationManager =
      (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
      //            OnGPS();
    } else {
      GPSTracker gps = new GPSTracker(this);

      // check if GPS enabled
      if (gps.canGetLocation()) {
        double latitude = gps.getLatitude();
        double longitude = gps.getLongitude();

        // \n is for new line
        //                Toast.makeText(getApplicationContext(), "Your Location is - \nLat: " + latitude + "\nLong: " + longitude, Toast.LENGTH_LONG).show();

        if (latitude != 0 && longitude != 0) {
          insertintodb(latitude + "", longitude + "");

          if (Utils.isInternetConnected(getApplicationContext())) {
            getalllatlng();

            String[] idArr = latlngarr.toArray(new String[latlngarr.size()]);
            System.out.println("Selected id>>>>>>> " + latlngarr);
            //                    StringBuilder sb = new StringBuilder();
            //                    for (int i = 0; i < idArr.length; i++) {
            //                        sb.append(idArr[i]).append(",");
            //                    }

            current_update_location(
              sharedPreference.getPreferenceString(
                MySharedPreference.COMPANY_ID
              ),
              sharedPreference.getPreferenceString(MySharedPreference.USER_ID),
              latlngarr.toString()
            );
            //                    dellatlng();
          }
        } else {}
      } else {
        // can't get location
        // GPS or Network is not enabled
        // Ask user to enable GPS/network in settings
        //                gps.showSettingsAlert();
      }
    }
  }

  private void getalllatlng() {
    latlngarr = new ArrayList<>();
    db.open();
    Cursor c = db.getAllContacts();
    if (c.moveToFirst()) {
      do {
        DisplayContact(c);
      } while (c.moveToNext());
    }
    db.close();
  }

  private void dellatlng() {
    //        db.open();
    db.clearTable();
    //        db.close();
  }

  private void DisplayContact(Cursor c) {
    // TODO Auto-generated method stub
    /*   Toast.makeText(getBaseContext(),"id: " + c.getString(0) + "\n" +"Name: " + c.getString(1) + "\n" +
        "Email: " + c.getString(2),
                Toast.LENGTH_LONG).show();*/

    System.out.println(
      "get lat>>>>>> " +
      c.getString(1) +
      "get lng>>>>>> " +
      c.getString(2) +
      "time stamp>>>>>> " +
      c.getString(3)
    );
    latlngarr.add(
      "{\"lat\":\"" +
      c.getString(1) +
      "\",\"lng\":\"" +
      c.getString(2) +
      "\",\"battery\":\"" +
      battery_percent +
      "\",\"timeStamp\":\"" +
      c.getString(3) +
      "\"}"
    );
    //        sessionManager.setSavedcity(sb.toString());

    //        db.open();

    //        db.close();
  }

  private void insertintodb(String lat, String lng) {
    Date today = new Date();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String dateToStr = format.format(today);
    db.open();
    db.insertContact(lat + "", lng + "", dateToStr);
    db.close();
  }

  //-----------------------------Get current Lat Long-------------------------

  private void OnGPS() {
    final AlertDialog.Builder builder = new AlertDialog.Builder(this);
    builder
      .setMessage("Enable GPS")
      .setCancelable(false)
      .setPositiveButton(
        "Yes",
        new DialogInterface.OnClickListener() {
          @Override
          public void onClick(DialogInterface dialog, int which) {
            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
          }
        }
      )
      .setNegativeButton(
        "No",
        new DialogInterface.OnClickListener() {
          @Override
          public void onClick(DialogInterface dialog, int which) {
            dialog.cancel();
          }
        }
      );
    builder.show();
    //        alertDialog.show();
  }

  //---------------------------Send Location after 5 minute----------

  class LocationAsyncTask extends AsyncTask<String, String, String> {

    @Override
    protected void onPreExecute() {
      super.onPreExecute();
    }

    @Override
    protected String doInBackground(String... strings) {
      return null;
    }

    @Override
    protected void onPostExecute(String s) {
      super.onPostExecute(s);
      getcurrentlocation();
      new Handler()
      .postDelayed(
          new Runnable() {
            @Override
            public void run() {
              new LocationAsyncTask().execute();
            }
          },
          60000 * LOCATION_INTERVAL
        );
    }
  }

  //-----------------------------Updatelocation----------------------------------

  public void current_update_location(String uid, String empId, String latlng) {
    JSONObject loginRequest = new JSONObject();
    try {
      loginRequest.put("companyId", uid);
      loginRequest.put("empId", empId);
      //            loginRequest.put("empTimelineList", latlng);
      loginRequest.put("empTimelineList", new JSONArray(latlng));
      System.out.println("location parameter>>>>>> " + loginRequest);
    } catch (Exception e) {
      e.printStackTrace();
    }
    myVolley.JsonRequest(
      UtilityFunctions.getBaseUrl() + "location/save_location_log",
      loginRequest,
      new MyVolley.jsonCallback() {
        @Override
        public void onSuccess(JSONObject jsonObject) {
          try {
            System.out.println(
              "location status>>>>>> " + jsonObject.toString()
            );

            boolean status = jsonObject.getBoolean("success");

            if (status) {
              dellatlng();
            } else {}
          } catch (JSONException e) {
            e.printStackTrace();
          }
          UtilityFunctions.dismissLoadingDialog();
        }

        @Override
        public void onFail(VolleyError error) {
          UtilityFunctions.dismissLoadingDialog();
          //                Toast.makeText(getApplicationContext(), "Server error Please try again.", Toast.LENGTH_SHORT).show();

        }
      }
    );
  }
}
