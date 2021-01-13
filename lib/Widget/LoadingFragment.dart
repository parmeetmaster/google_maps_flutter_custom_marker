import 'package:flutter/material.dart';



class LoadingFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size=    MediaQuery.of(context).size;
    return Container(
      height:size.height,
      width:size.width,
      color: Colors.green,
      child: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
