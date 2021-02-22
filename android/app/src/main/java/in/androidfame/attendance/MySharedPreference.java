package in.androidfame.attendance;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by shali on 8/6/18.
 */

public class MySharedPreference {
    public static final String TOKEN_ID = "TOKEN_ID";
    public static final String IS_LOGGED_IN = "IS_LOGGED_IN";
    public static final String VERSION_CODE = "VERSION_CODE";
    public static final String ACT_TYPE = "ACT_TYPE";
    public static final String USER_ID = "USER_ID";
    public static final String FACE_API = "FACE_API";
    public static final String APP_FEATURES = "APP_FEATURES";
    public static final String COMPANY_ID = "COMPANY_ID";
    public static final String USER_NAME = "USER_NAME";
    public static final String COMPANY_NAME = "COMPANY_NAME";
    public static final String CHECKED_IN = "CHECKED_IN";
    public static final String CHECKED_IN_TIME = "CHECKED_IN_TIME";
    public static final String ROLE = "ROLE";
    public static final String ADMIN = "ADMIN";
    public static final String PUSH_CODE = "PUSH_CODE";
    public static final String RATING_FIRST = "RATING_FIRST";
    private String preferenceName = "android_fame";
    private SharedPreferences sharedPref;

    public MySharedPreference(Context context) {
        sharedPref = context.getSharedPreferences(
                preferenceName, Context.MODE_PRIVATE);
    }

    public static void clearPreference(Context context) {
        SharedPreferences sharedPref = context.getSharedPreferences(
                "android_fame_flut", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.clear().apply();
    }

    public String getPreferenceString(String data) {
        return sharedPref.getString(data, "");
    }

    public int getPreferenceInt(String data) {
        return sharedPref.getInt(data, 1);
    }

    public long getPreferenceLong(String data) {
        return sharedPref.getLong(data, 1);
    }

    public Boolean getPreferenceBoolean(String data) {
        return sharedPref.getBoolean(data, false);
    }

    public void putPreferenceString(String key, String value) {
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(key, value);
        editor.apply();
    }

    public void logout() {
        String value = "";
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putBoolean(MySharedPreference.IS_LOGGED_IN, false);
        editor.putString(MySharedPreference.ROLE, value);
        editor.putString(MySharedPreference.USER_NAME, value);
        editor.putString(MySharedPreference.COMPANY_NAME, value);
        editor.putString(MySharedPreference.RATING_FIRST, value);
        editor.apply();
    }

    public void putPreferenceBoolean(String key, Boolean value) {
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putBoolean(key, value);
        editor.apply();
    }

    public void putPreferenceInt(String key, int value) {
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt(key, value);
        editor.apply();
    }
    public void putPreferenceLong(String key, long value) {
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putLong(key, value);
        editor.apply();
    }

}
