

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




  @override
  Widget build(BuildContext context) {

    final provider= Provider.of<DetailPlaceProvider>(context, listen: false);
  //  print("This is latitude ${widget.markers.last.position.latitude} This is longitude ${widget.markers.last.position.longitude}");

    /*if(widget.markers!=null)
    provider.getLocatonDetails("${widget.markers.last.position.latitude} ","${widget.markers.last.position.longitude}");
*/
    if(widget.latLng!=null){
      provider.getLocatonDetails("${widget.latLng.latitude} ","${widget.latLng.longitude}");
    }

    return Scaffold(
      body: Consumer<DetailPlaceProvider>(

        builder: (context,value,child) {
          return ((){
            if(widget.place!=null){return Container(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Text("This is latitude ${widget.markers.last.position.latitude} This is longitude ${widget.markers.last.position.longitude}"),
                  Text("${provider.markerAddress}"),

                  SizedBox(height: 50 ),
                  ((){
                    if(widget.place!=null){
                      return  Text("${widget.place.placeDetails.formattedAddress}");
                    }else{
                      return Container();
                    }

                  }())

                ],
              ),
            );
            }else{
              return Column(
                children: [
                  SizedBox(height: 40,),
                  Text("This is latitude ${widget.latLng.latitude} This is longitude ${widget.latLng.longitude}"),


                ],
              );

            }

          }());
        }
      ),
    );

  }
}
