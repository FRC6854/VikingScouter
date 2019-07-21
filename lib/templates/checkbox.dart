import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';

Widget checkboxWidget (String name, int value, int index, Function onChange) {
  bool checkboxValue;

  if(value == 0)
    checkboxValue = false;
  if(value == 1)
    checkboxValue = true;

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
        Checkbox(
          value: checkboxValue,
          onChanged: (boolValue) => onChange(index, boolValue),
          checkColor: Constants.darkAccent,
          activeColor: Constants.darkBG,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )
      ],
    )
  );
}