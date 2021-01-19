import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/flutter_places.dart';
import 'package:google_maps_testing/Utils/DioManager.dart';
import 'package:logger/logger.dart';

class DetailPlaceProvider extends ChangeNotifier {
  String markerAddress = "Blank";

  DioManager manager = new DioManager();
  var logger = Logger();


  Future<List<String>> getLocatonDetails(String lat, String lng,[String TAG]) async {
    Response resp = await manager.getGooglePlaceDetailsApiFunction(lat, lng);
    TAG??="RESPONSE";
    logger.i("$TAG,geocoding response ${resp.data.toString()}");
    //print("$TAG,geocoding response ${resp.data.toString()}");
    List<dynamic> list = resp.data["results"] as List;

    markerAddress = "${list[0]["formatted_address"]}";
    notifyListeners();
  }


}
