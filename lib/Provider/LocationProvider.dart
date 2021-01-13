import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  bool isgpsServiceEnable = true;
  bool isGpsPermissionFragmentEnable=false;
bool isInitLocationLoaded=false;
  LocationPermission permission;
  Future<void> checkPermission() async {


    isgpsServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (!isgpsServiceEnable) {
      isgpsServiceEnable = false;


      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
  /*Logic to Gps Screen is Enable or not*/
    if (permission == LocationPermission.deniedForever) {
        if(isGpsPermissionFragmentEnable==false){
          isGpsPermissionFragmentEnable=true;
          notifyListeners();
        }
        /*Logic to Gps Screen is Enable or not Ends here*/
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {

        await checkPermission();

        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          notifyListeners();
        }// refresh screen when permission have it


        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }// if permission is denied scope


    }




  }

  Future<Position> _determinePosition() async {
   checkPermission();

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

  Future<CameraPosition> initlocationLoad() async {
    isInitLocationLoaded=true;
    return getCurruntLocation();
  }
refreshScreen(){
    notifyListeners();
}



}
