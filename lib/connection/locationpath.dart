import '../utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

var apiKey = AppUtils.GKEY;

class Locationpath {
  Future getRouteCoordinates(LatLng l1, LatLng l2) async {
    var url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey';
    print('LocationPath: $url');
    var response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values['routes'][0]['overview_polyline']['points'];
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
