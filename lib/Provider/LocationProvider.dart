import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  bool isgpsServiceEnable = true;
  bool isPermissionEnable = true;
  bool isGpsPermanentDenied = false;

  Future<void> _checkPermission() async {
    LocationPermission permission;

    isgpsServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (!isgpsServiceEnable) {
      isgpsServiceEnable = false;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      isPermissionEnable = false;
      isGpsPermanentDenied = true;
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        isPermissionEnable = false;
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
  }

  Future<Position> _determinePosition() async {
    _checkPermission();

    return await Geolocator.getCurrentPosition();
  }

  Future<CameraPosition> getCurruntLocation() async {
    Position position = await _determinePosition();
    if (position != null) {
      CameraPosition _curruntLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
      return _curruntLocation;
    } else {
      return null;
    }
  }
}
