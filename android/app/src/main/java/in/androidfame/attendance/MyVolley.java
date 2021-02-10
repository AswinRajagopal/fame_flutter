package in.androidfame.attendance;

import android.content.Context;
import android.content.DialogInterface;
import android.widget.Toast;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

// import androidx.appcompat.app.AlertDialog;
// import in.androidfame.attendance.utility.UtilityFunctions;


public class MyVolley {

    private RequestQueue queue;
    Context context;

    public MyVolley(Context context) {
        queue = Volley.newRequestQueue(context);
        this.context = context;
    }

    public void JsonRequest(String url, JSONObject request, final jsonCallback callback) {

// Request a string response from the provided URL.
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest
                (Request.Method.POST, url, request, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {

                        callback.onSuccess(response);
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        callback.onFail(error);
                    }
                }) {

        };
        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(
                30000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
        // if (UtilityFunctions.isInternetAvailable(context)) {
            queue.add(jsonObjectRequest);
        // }else {
            // noInternetDial();
//            Toast.makeText(context, "Please Check your internet connection", Toast.LENGTH_LONG).show();
            // callback.onFail(new VolleyError());
        // }
    }

    public interface stringCallback {
        public void onSuccess(String response);

        public void onFail(VolleyError error);
    }

    public interface jsonCallback {
        public void onSuccess(JSONObject response);

        public void onFail(VolleyError error);
    }
}
