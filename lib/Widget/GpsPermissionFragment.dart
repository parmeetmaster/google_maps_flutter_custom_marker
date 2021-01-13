import 'package:flutter/material.dart';

class GpsPermissionFragment extends StatefulWidget {
  @override
  _GpsPermissionFragmentState createState() => _GpsPermissionFragmentState();
}

class _GpsPermissionFragmentState extends State<GpsPermissionFragment> {
  @override
  Widget build(BuildContext context) {
    Size size=    MediaQuery.of(context).size;
    return Container(
        height:size.height,
        width:size.width,
        color: Colors.amber,
        child: Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}
