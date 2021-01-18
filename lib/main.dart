import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_places/flutter_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Provider/DetailPlaceProvider.dart';
import 'Provider/LocationProvider.dart';
import 'Screens/DisplayPlaceDetailsScreen.dart';
import 'Utils/UUIDGenerator.dart';
import 'Widget/GpsPermissionFragment.dart';
import 'Widget/LoadingFragment.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'dart:math';
/*
* This app need to update min sdk version to 24 in order to run map api
*
* */
/*void main() => runApp(MyApp());*/

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => LocationProvider()),
    ChangeNotifierProvider(create: (ctx) => DetailPlaceProvider())
  ],
  child:MyApp())
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Place place;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 10.151926040649414);
  Set<Marker> _markers = {};
  GlobalKey<AutoCompleteTextFieldState<String>> key  = new GlobalKey();



 _getSearchButton()  {
   final provider= Provider.of<LocationProvider>(context, listen: false);
   return Align(
     alignment: Alignment.topRight,
     child:
     Container(
       width: 120,
       margin: EdgeInsets.only(top:30,right: 20),

       child: ElevatedButton(
         child: Row(
           children: [
             Icon(Icons.search),
             Text(" Search",style: TextStyle(fontSize: 17),),
           ],
         ),
         onPressed: () async {
          place  = await FlutterPlaces.show(

             context: context,
             apiKey: "AIzaSyBvD73khNYpYFjm8RA5b_iKfZO8RPYJpyA",
             modeType: ModeType.OVERLAY,
            searchOptions:  SearchOptions(sessionToken:UuidGenerator().getV4Uuid()),
           );
           provider.setMarkerUsingPlaceDetails(place);
         },
         style: ElevatedButton.styleFrom(
           primary: Colors.blue,
           onPrimary: Colors.white,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(32.0),
           ),
         ),
       ),
     )

   );


 }

  _getContinoueButton(Function call)  {
    return Align(
        alignment: Alignment.bottomRight,
        child:
        Container(
          width: 130,
          margin: EdgeInsets.only(bottom:30,right: 20),

          child: ElevatedButton(

            child: Row(
              children: [
                Icon(Icons.arrow_forward),
                Text(" Continue",style: TextStyle(fontSize: 17),),
              ],
            ),
            onPressed:call,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ),
        )

    );


  }


  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<LocationProvider>(context, listen: false);
    return new Scaffold(
      body: Consumer<LocationProvider>(
        builder: (context, value,child) {

           return FutureBuilder<CameraPosition>(
               future: value.initlocationLoad(),
               builder: (context, AsyncSnapshot<CameraPosition> snapshot) {
                 return Stack(
                   children: [
                     (){
                       if(snapshot.data==null) {  // on start its returns null snapshot data. When future done its future builder block called again
                        return LoadingFragment();
                       }
                       else if(snapshot.data!=null) {
                         if(provider.isFirstLoadDone==false){
                           provider.markers.add(Marker(
                               markerId: MarkerId("1234"),
                               position: LatLng(provider.locationData.latitude,provider.locationData.longitude),
                               icon: pinLocationIcon));
                         }else{
                           // do nothing
                         }
                         return GoogleMap(mapType: MapType.normal,
                           initialCameraPosition: provider.curruntCameraPosition,
                           markers: provider.markers,
                           onMapCreated: (GoogleMapController controller) {
                             _controller.complete(controller);
                             provider.controller=controller;
                           },
                             onTap: provider.onTapAddMarker,
                         );
                       }

                     }(),
                     // generate Input Text Box code here
                       (){
                         if(snapshot.data!=null){
                           return _getSearchButton();
                         }else{
                            return Container();
                         }
                          }(),
                         (){
                       //dchfdhydfhh
                       if(snapshot.data!=null){
                         return _getContinoueButton((){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => DisplayPlaceDetailsRoute(markers:provider.markers,place:provider.place)),
                           );

                         });
                       }else{
                         return Container();
                       }
                     }()

                   ],
                 );
               }
           );
         }

      ),
/*      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );




  }


  Widget _loadScreenFragement() {
    Size size=    MediaQuery.of(context).size;
    return Container(
        height:size.height,
        width:size.width,
        color: Colors.amber,
        child:Center(child:CircularProgressIndicator()));

  }
  LatLng pinPosition = LatLng(28.6442197, 77.2157713);

  // these are the minimum required values to set
  // the camera position
  var pinLocationIcon;





}


