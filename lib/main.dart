import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Provider/LocationProvider.dart';
import 'Widget/GpsPermissionFragment.dart';
import 'Widget/LoadingFragment.dart';
import 'package:provider/provider.dart';

/*
* This app need to update min sdk version to 24 in order to run map api
*
* */
/*void main() => runApp(MyApp());*/

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => LocationProvider())
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
                       if( provider.permission==LocationPermission.deniedForever || provider.isgpsServiceEnable==false){
                       return GpsPermissionFragment();
                       }
                      else if(snapshot.data==null) {
                        provider.checkPermission();
                        provider.refreshScreen();
                         return LoadingFragment();
                       }
                       else if(snapshot.data!=null) {
                         return GoogleMap(mapType: MapType.normal,
                           initialCameraPosition: snapshot.data,
                           markers: _markers,
                           onMapCreated: (GoogleMapController controller) {
                             _controller.complete(controller);
                           },
                         );
                       }

                     }()

                   ],
                 );
               }
           );
         }

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
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

  Future<void> _goToTheLake() async {
    final CameraPosition _kLake = CameraPosition(
        bearing: 90.8334901395799,
        target: pinPosition,
        tilt: 0,
        zoom: 25.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'flags/bic.png')
        .then((onValue) {
      pinLocationIcon = onValue;

      _markers.add(Marker(
          markerId: MarkerId("1234"),
          position: pinPosition,
          icon: pinLocationIcon));
      setState(() {});
    });
  }



}
