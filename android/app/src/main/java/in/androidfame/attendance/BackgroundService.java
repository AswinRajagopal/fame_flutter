package in.androidfame.attendance;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.BatteryManager;
import android.os.Binder;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.android.volley.VolleyError;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import in.androidfame.attendance.R;
// import in.androidfame.attendance.layout.Utils;
import in.androidfame.attendance.MyVolley;
import in.androidfame.attendance.DBAdapter;
import in.androidfame.attendance.GPSTracker;
import in.androidfame.attendance.MySharedPreference;
// import in.androidfame.attendance.UtilityFunctions;


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
    private static int LOCATION_INTERVAL = 15;
    private final int LOCATION_DISTANCE = 0;
    FusedLocationProviderClient fusedLocationProviderClient;
    String battery_percent, current_date_time;
    String companyId,empId;

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
//        if(intent!=null) {
//            empId = intent.getExtras().getString("empId");
//            companyId = intent.getExtras().getString("companyId");
//        }
//        BackgroundService.LOCATION_INTERVAL = Integer.parseInt(intent.getExtras().getString("trackingInterval"));
        super.onStartCommand(intent, flags, startId);
        return START_STICKY;
    }

    @Override
    public void onCreate() {
        Log.i(TAG, "onCreate");
//        Toast.makeText(getApplicationContext(), "Service start", Toast.LENGTH_SHORT).show();
        db = new DBAdapter(getApplicationContext());
        this.registerReceiver(this.mBatInfoReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(12345678, getNotification());
        }
        myVolley = new MyVolley(getApplicationContext());
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(getApplicationContext());
        sharedPreference = new MySharedPreference(getApplicationContext());
//        LOCATION_INTERVAL = sharedPreference.getPreferenceInt("trackingInterval");
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


    private Notification getNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    "channel1",
                    "my channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
            Notification.Builder builder = new Notification.Builder
                    (getApplicationContext(), "channel1")
                    .setContentTitle("FaME is running in background")
                    .setSmallIcon(R.drawable.ic_notification);
            return builder.build();
        }
        return null;
    }


    public class LocationServiceBinder extends Binder {
        public BackgroundService getService() {
            return BackgroundService.this;
        }
    }


    private void getcurrentlocation() {
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
//            OnGPS();
        } else {
            GPSTracker gps = new GPSTracker(this);

            // check if GPS enabled
            if (gps.canGetLocation()) {

                double latitude = gps.getLatitude();
                double longitude = gps.getLongitude();

                if (latitude != 0 && longitude != 0) {
                    insertintodb(latitude + "", longitude + "");

//                    if (isInternetConnected(getApplicationContext())) {

                        getalllatlng();

                        String[] idArr = latlngarr.toArray(new String[latlngarr.size()]);
                        System.out.println("Selected id>>>>>>> " + latlngarr);

                        current_update_location(sharedPreference.getPreferenceString(MySharedPreference.COMPANY_ID), sharedPreference.getPreferenceString(MySharedPreference.USER_ID), latlngarr.toString());
//                    dellatlng();
//                    }
                }


            } else {
                // can't get location
                // GPS or Network is not enabled
                // Ask user to enable GPS/network in settings
//                gps.showSettingsAlert();
            }
        }
    }

    public boolean isInternetConnected(Context mContext) {

		try {
			ConnectivityManager connect = null;
			connect = (ConnectivityManager) mContext
					.getSystemService(Context.CONNECTIVITY_SERVICE);

			if (connect != null) {
				NetworkInfo resultMobile = connect
						.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);

				NetworkInfo resultWifi = connect
						.getNetworkInfo(ConnectivityManager.TYPE_WIFI);

				if ((resultMobile != null && resultMobile
						.isConnectedOrConnecting())
						|| (resultWifi != null && resultWifi
								.isConnectedOrConnecting())) {
					return true;
				} else {
					return false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
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
        db.clearTable();
    }


    private void DisplayContact(Cursor c) {
        // TODO Auto-generated method stub

        System.out.println("get lat>>>>>> " + c.getString(1) + "get lng>>>>>> " + c.getString(2) + "time stamp>>>>>> " + c.getString(3));
        latlngarr.add("{\"lat\":\"" + c.getString(1) + "\",\"lng\":\"" + c.getString(2) + "\",\"battery\":\"" + battery_percent + "\",\"timeStamp\":\"" + c.getString(3) + "\"}");

    }

    private void insertintodb(String lat, String lng) {
        Date today = new Date();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateToStr = format.format(today);
        db.open();
        db.insertContact(lat + "",
                lng + "", dateToStr);
        db.close();
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
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    new LocationAsyncTask().execute();
                }
            }, 60000 * LOCATION_INTERVAL);

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
        myVolley.JsonRequest("http://androidapp.diyosfame.com:8090/v1/api/location/save_location_log", loginRequest, new MyVolley.jsonCallback() {
            @Override
            public void onSuccess(JSONObject jsonObject) {
                try {
                    System.out.println("location status>>>>>> " + jsonObject.toString());
                    boolean status = jsonObject.getBoolean("success");
                    if (status) {
                        dellatlng();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFail(VolleyError error) {
            }

        });
    }


}