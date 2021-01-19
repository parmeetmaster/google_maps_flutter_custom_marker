import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_places/flutter_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../Screens/DisplayPlaceDetailsScreen.dart';
import 'package:google_maps_testing/Utils/DioManager.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier{
  final Location location = Location();
  LocationData locationData;
  Place place;
  String _error;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  var autocompleteTextController=TextEditingController();
  List<String> placeSuggestions=[];
  Set<Marker> markers = {};
  bool isFirstLoadDone=false;
  GoogleMapController controller;
  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      _permissionGranted = permissionRequestedResult;
    }
  }

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    _serviceEnabled = serviceEnabledResult;
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      _serviceEnabled = serviceRequestedResult;
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<LocationData> _getLocation() async {
    print("tag $location");
    _error = null;

    try {
      while(true){
        await Future.delayed(Duration(seconds: 1));
        final LocationData _locationResult = await location.getLocation();
        locationData = _locationResult;
        print("TAG BLOCK ${locationData.latitude} , ${locationData.longitude}");
        if (locationData.longitude > 0 || locationData.latitude > 0 ||
            locationData.longitude < 0 || locationData.latitude < 0) {
       return locationData;
        }
      }



    }catch(err){
      print("TAG ERROR ${err.toString()}");
    }
  }

  CameraPosition curruntCameraPosition = null;

  setCameraData() {
    if(this.isFirstLoadDone==false) {
      return curruntCameraPosition = CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 14.4746,
      );
    }
  else{
      return curruntCameraPosition;
    }

  }

  Future<CameraPosition> initlocationLoad() async {
if(curruntCameraPosition!=null)return curruntCameraPosition;

    await _checkPermissions();
    await _requestPermission();
    await _checkService();
    await _requestService();
    await _getLocation();
    print("TAG DOWN ${locationData.latitude}");

 return await setCameraData();
  }
  // Here Below places and sugesstion work started

  DioManager manager=new DioManager();
  Future<List<String>>updateSuggestions(String locationsuggestions,GlobalKey<AutoCompleteTextFieldState<String>> key) async {
    Response resp=  await manager.getGooglePlacesSuggestion(locationsuggestions);
   List<dynamic> list= resp.data["predictions"] as List;
    this.placeSuggestions=[];
      for  (var ls in list){
      placeSuggestions.add("${ls["structured_formatting"]["main_text"] as String}");
       print("${ ls["structured_formatting"]["main_text"]}");
      key.currentState.suggestions=placeSuggestions;
     }

  }

Future<void> setUpdatedLocation(String submittedText){
  for(var ls in placeSuggestions){
   if(ls==submittedText){
     print("item found in list");
   }

  }
}

  onTextInputSubmit(String text){
    if (text != "") {
      print("textSubmitted $text");
    }

  }

/*  onTapAddMarker(LatLng latLng){
   markers.remove;
  markers.add(Marker(
        markerId: MarkerId("1234"),
        position: LatLng(latLng.latitude,latLng.longitude),
       ));
  isFirstLoadDone=true;
  notifyListeners();
  }*/

  Future<void> setMarkerUsingPlaceDetails(Place place) async {
    isFirstLoadDone=true;
    this.place=place;
 /*   markers.remove;
    markers.add(new Marker(
    markerId: MarkerId("1234"),
    position: LatLng(place.placeDetails.geometry.location.lat,place.placeDetails.geometry.location.lng),
      )
      );*/


    // Move camera to location
  final curruntCameraPosition =await CameraPosition(
      target: LatLng(place.placeDetails.geometry.location.lat, place.placeDetails.geometry.location.lng),
      zoom: 14.4746,
    );
  CameraUpdate cameraUpdate= CameraUpdate.newCameraPosition(curruntCameraPosition);
   controller.moveCamera(cameraUpdate);
        notifyListeners();

  }

  refreshScreen(){
    notifyListeners();
  }

  performActionWithFixedMarker({dynamic constraints,BuildContext context}) async {

    LatLng l=  await controller.getLatLng(ScreenCoordinate(x: ((constraints.maxWidth)  /2).toInt(),y: (((constraints.maxHeight)/2 )).toInt()));

    Navigator.push(context,
      MaterialPageRoute(builder: (context) => DisplayPlaceDetailsRoute(latLng: l,place: place,)),
    );
  }




}

