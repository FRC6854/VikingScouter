import 'package:flutter/material.dart';
import 'package:viking_scouter/util/constants.dart';

Widget headerWidget (String name, int index) {
  return Container(
    margin: EdgeInsets.only(left: 50, right: 50),
    child: Column(
      children: <Widget>[
        Divider(
          height: 30,
          color: Constants.darkAccent,
          thickness: 2
        ),
        Text(name, style: TextStyle(
          fontFamily: "Open Sans",
          fontWeight: FontWeight.w300,
          fontSize: 20.0
        )),
        Divider(
          height: 30,
          color: Constants.darkAccent,
          thickness: 2
        )
      ], 
    )
  );
}