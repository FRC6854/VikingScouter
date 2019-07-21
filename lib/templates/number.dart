import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';

Widget numberWidget (String name, int value, int index, Function onChange) {
  return Container(
    margin: EdgeInsets.only(left: 50, right: 50),
    child: Column(
      children: <Widget>[
        Text(name, style: TextStyle(
          fontFamily: "Open Sans",
          fontWeight: FontWeight.w400,
          fontSize: 15.0
        )),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        TextField(
          decoration: new InputDecoration(labelText: "Enter number", labelStyle: TextStyle(
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
            color: Constants.darkAccent
          )),
          keyboardType: TextInputType.number,
          onSubmitted: (number) => onChange(index, int.parse(number)),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
      ],
    )
  );
}