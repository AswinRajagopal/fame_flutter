import 'package:shared_preferences/shared_preferences.dart';

class MyPref {
  static String LOGGED_IN = "logged_in";
  static String USER_ID = "user_id";
  static String COMPANY_ID = "company_id";
  static String CART_ITEMS = "cart_items";
  static String OPENED_DATE = "date_opened";
  static String COMPANY_NAME = "company_name";
  static String USER_NAME = "USER_NAME";
  static String ROLE = "ROLE";

  SharedPreferences prefs;

  MyPref() {
    inPref();
  }

  inPref() async {
    final prefs = await SharedPreferences.getInstance();
  }

  getVal(key) async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'false';
  }

  setVal(key, value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

}
