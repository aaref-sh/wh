import 'package:location/location.dart';
import 'package:wh/all.dart';

Future<void> getPermissions() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

void initLocation() {
  try {
    Location location = Location();

    try {
      location.enableBackgroundMode(enable: true);
    } on Exception catch (e) {
      // TODO
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      lastLocation = currentLocation;
    });
    getPermissions();
  } on Exception catch (e) {
    // TODO
  }
}
