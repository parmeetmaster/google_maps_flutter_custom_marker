import 'dart:io';

import 'package:dio/dio.dart';

//import '../Constants/Constants.dart';
import '../Constants/Constants.dart';
import '../Utils/UUIDGenerator.dart';

class DioManager {
  Dio dio = new Dio();
  Response response;
  UuidGenerator uuidGenerator = new UuidGenerator();

  Future<Response> getGooglePlacesSuggestion(String locationString) async {
    try {
      return response = await dio.get(
          "${Constants.$googlePlacesApiUrl}?input=$locationString&key=${Constants.$apiToken}&sessiontoken=${uuidGenerator.getV4Uuid()}");
      print("places api response ${response.data.toString()}");
    } on DioError catch (err) {
      print("Dio Error is ${err.message}");
      handleError(err);
    } on SocketException catch (e) {
      print("error status code ${e.message}"); //handle internet not connected
    } on FormatException catch (e) {
      print("error status code ${e.message}");
    } catch (e) {
      print("error status code ${e.message}");
    }
  }

  Future<Response> getGooglePlaceDetailsApiFunction(String latitude,String longitude) async {
    try {
      return response = await dio.get(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants.$apiToken}");
      print("places api response ${response.data.toString()}");
    } on DioError catch (err) {
      print("Dio Error is ${err.message}");
      handleError(err);
    } on SocketException catch (e) {
      print("error status code ${e.message}"); //handle internet not connected
    } on FormatException catch (e) {
      print("error status code ${e.message}");
    } catch (e) {
      print("error status code ${e.message}");
    }
  }

}

void handleError(DioError err) {}
