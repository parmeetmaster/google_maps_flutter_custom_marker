

import 'package:flutter/material.dart';
import 'package:flutter_places/src/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';
import 'package:google_maps_testing/Provider/DetailPlaceProvider.dart';
import 'package:provider/provider.dart';



class DisplayPlaceDetailsRoute extends StatefulWidget {
  Set<Marker> markers;
  Place place;
  LatLng latLng;

  DisplayPlaceDetailsRoute({this.latLng, this.markers,this.place});


  @override
  _DisplayPlaceDetailsRouteState createState() => _DisplayPlaceDetailsRouteState();
}

class _DisplayPlaceDetailsRouteState extends State<DisplayPlaceDetailsRoute> {


TextStyle commonTextStyle=new TextStyle(fontSize: 20,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {

    final provider= Provider.of<DetailPlaceProvider>(context, listen: false);
    if(widget.markers!=null){
      print("This marker is latitude ${widget.markers.last.position.latitude} This is longitude ${widget.markers.last.position.longitude}");
      provider.getLocatonDetails("${widget.markers.last.position.latitude} ","${widget.markers.last.position.longitude}","marker location");
    }

    print("This is custom marker");
    if(widget.latLng!=null){
      provider.getLocatonDetails("${widget.latLng.latitude} ","${widget.latLng.longitude}","center icon location");
    }

    return Scaffold(
      body: Consumer<DetailPlaceProvider>(

        builder: (context,value,child) {
          return ((){
            return Container(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Text("Latitude ${widget.latLng.latitude}",style:commonTextStyle ),
                  Text("Longitude ${widget.latLng.longitude}",style: commonTextStyle,),

                  ((){

                      return  Column(
                        children: [
                          Padding( padding: EdgeInsets.all(50), child: Column(
                            children: [
                              Text("GeoCoded Address",style: commonTextStyle,),
                              SizedBox(height: 10,),
                              Text("${provider.markerAddress}"),
                              Text("Place Search Address",style: commonTextStyle,),
                              widget.place!=null ?Text("${widget.place.placeDetails.formattedAddress}"):Text("place not searched")

                            ],
                          )),
                        ],
                      );


                  }())

                ],
              ),
            );


          }());
        }
      ),
    );

  }
}
