import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_testing/Utils/DioManager.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier{
  final Location location = Location();
  LocationData locationData;

  String _error;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  var autocompleteTextController=TextEditingController();
  List<String> placeSuggestions=[];

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

  CameraPosition currentPosition = null;

  setCameraData() {
    return currentPosition = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: 14.4746,
    );
  }

  Future<CameraPosition> initlocationLoad() async {
if(currentPosition!=null)return currentPosition;

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



}

