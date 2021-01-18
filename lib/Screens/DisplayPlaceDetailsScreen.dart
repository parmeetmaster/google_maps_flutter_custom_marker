

import 'package:flutter/material.dart';
import 'package:flutter_places/src/models/place.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';
import 'package:google_maps_testing/Provider/DetailPlaceProvider.dart';
import 'package:provider/provider.dart';



class DisplayPlaceDetailsRoute extends StatefulWidget {
  Set<Marker> markers;
  Place place;

  DisplayPlaceDetailsRoute({this.markers,this.place});


  @override
  _DisplayPlaceDetailsRouteState createState() => _DisplayPlaceDetailsRouteState();
}

class _DisplayPlaceDetailsRouteState extends State<DisplayPlaceDetailsRoute> {



_gettest() async{


}

  @override
  Widget build(BuildContext context) {
    _gettest();
    final provider= Provider.of<DetailPlaceProvider>(context, listen: false);
    print("This is latitude ${widget.markers.last.position.latitude} This is longitude ${widget.markers.last.position.longitude}");

    provider.getLocatonDetails("${widget.markers.last.position.latitude} ","${widget.markers.last.position.longitude}");

    return Scaffold(
      body: Consumer<DetailPlaceProvider>(

        builder: (context,value,child) {
          return Container(
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
        }
      ),
    );

  }
}
