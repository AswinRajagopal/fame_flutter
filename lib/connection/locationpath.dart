import '../utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

var apiKey = AppUtils.GKEY;

class Locationpath {
  Future getRouteCoordinates(LatLng l1, LatLng l2) async {
    var chkDistance = await getDistance(l1, l2);
    if (chkDistance == 0) {
      return 'notincluded';
    } else {
      var url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey';
      // print('LocationPath: $url');
      var response = await http.get(url);
      Map values = jsonDecode(response.body);
      return values['routes'][0]['overview_polyline']['points'];
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future getDistance(LatLng l1, LatLng l2) async {
    var url = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${l1.latitude},${l1.longitude}&destinations=${l2.latitude},${l2.longitude}&key=$apiKey';
    // print('LocationPath: $url');
    var response = await http.get(url);
    Map values = jsonDecode(response.body);
    // var fullText = values['rows'][0]['elements'][0]['distance']['text'];
    var distanceValue = values['rows'][0]['elements'][0]['distance']['value'];
    // var distance = fullText.split(' ')[0];
    // var distanceType = fullText.split(' ')[1];
    // if (distanceType == 'm') {
    //   distance = double.parse(distance) / 1000;
    // }
    var dis = double.parse(distanceValue.toString());
    // print('distance: $dis');
    if (dis < 100) {
      return 0;
    }
    return double.parse(distanceValue.toString()) / 1000;
  }
}
