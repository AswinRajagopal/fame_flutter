// import 'package:battery/battery.dart';
// import 'remote_services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';

// class LocationUpdates {
//   // ignore: always_declare_return_types
//   static requestPermissions() async {
//     await bg.BackgroundGeolocation.requestPermission();
//   }

//   static Future<void> stopLocationUpdates(BuildContext context) async {
//     await notifyUserStoppedLocationUpdates(context);
//     await bg.BackgroundGeolocation.stop();
//   }

//   static Future<bool> initiateLocationUpdates(context) async {
//     var permissionDenied = await arePermissionsDenied();
//     if (permissionDenied) {
//       showLocationPermissionsNotAvailableDialog(context);
//       return Future.value(false);
//     } else {
//       try {
//         await initiateLocationUpdatesInternal();
//         return Future.value(true);
//       } catch (ex) {
//         showLocationPermissionsNotAvailableDialog(context);
//         return Future.value(false);
//       }
//     }
//   }

//   static Future initiateLocationUpdatesInternal() async {
//     var latitude = '';
//     var longitude = '';
//     // var userId = await AppConstants.getDeviceId();
//     // Fired whenever a location is recorded
//     bg.BackgroundGeolocation.onLocation((bg.Location location) async {
//       print('[location] - $location');
//       latitude = location.coords.latitude.toString();
//       longitude = location.coords.longitude.toString();
//     });

//     // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
//     bg.BackgroundGeolocation.onMotionChange((bg.Location location) async {
//       print('[motionchange] - $location');
//       latitude = location.coords.latitude.toString();
//       longitude = location.coords.longitude.toString();
//     });

//     // Fired whenever the state of location-services changes.  Always fired at boot
//     bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
//       print('[providerchange] - $event');
//     });

//     await bg.BackgroundGeolocation.ready(
//       bg.Config(
//         url: '${RemoteServices.baseURL}/location/save_location_log',
//         method: 'POST',
//         maxBatchSize: 50,
//         params: {
//           'empId': RemoteServices().box.get('empid').toString(),
//           'companyId': RemoteServices().box.get('companyid').toString(),
//           'empTimelineList': [
//             {
//               'lat': latitude.toString(),
//               'lng': longitude.toString(),
//               'battery': await Battery().batteryLevel.toString(),
//               'timeStamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
//             },
//           ],
//         },
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         locationsOrderDirection: 'DESC',
//         distanceFilter: 10000,
//         forceReloadOnBoot: true,
//         // locationUpdateInterval: ,
//         maxDaysToPersist: 3,
//         debug: false,
//         autoSync: true,
//         triggerActivities: 'on_foot, walking, running',
//         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//         stopOnTerminate: false,
//         allowIdenticalLocations: true,
//         startOnBoot: true,
//         enableHeadless: true,
//         locationAuthorizationAlert: {
//           'titleWhenNotEnabled': 'Your location-services are disabled',
//           'titleWhenOff': 'Your location-services are disabled',
//           'instructions': 'Permitting ‘Always-on’ access to your device location is essential to provide location to server.',
//           'cancelButton': 'Cancel',
//           'settingsButton': 'Settings',
//         },
//         notification: bg.Notification(
//           title: 'FaME',
//           text: 'Your location is being tracked, but all data will be anonymous.',
//         ),
//         logLevel: bg.Config.LOG_LEVEL_OFF,
//       ),
//     ).then((bg.State state) {
//       if (!state.enabled) {
//         bg.BackgroundGeolocation.start();
//       }
//     });
//   }

//   static Future<bool> arePermissionsDenied() async => await Geolocator.checkPermission() != LocationPermission.always || await Geolocator.checkPermission() == LocationPermission.deniedForever;

//   static Future<void> notifyUserStoppedLocationUpdates(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           content: Text(
//             "We won't track your location and no anonymous location-based information will be sent to you",
//           ),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               child: Text(
//                 'Ok',
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static void showLocationPermissionsNotAvailableDialog(BuildContext context) {
//     LocationUpdates.requestPermissions();
//   }
// }
