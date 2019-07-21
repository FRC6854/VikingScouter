import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';

Widget headerWidget (String name, int index) {
  return Container(
    margin: EdgeInsets.only(left: 50, right: 50),
    child: Column(
      children: <Widget>[
        Divider(height: 20, color: Constants.darkAccent),
        Text(name, style: TextStyle(
          fontFamily: "Open Sans",
          fontWeight: FontWeight.w300,
          fontSize: 20.0
        )),
        Divider(height: 20, color: Constants.darkAccent)
      ], 
    )
  );
}