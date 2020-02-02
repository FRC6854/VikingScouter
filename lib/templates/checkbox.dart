import 'package:flutter/material.dart';
import 'package:viking_scouter/util/constants.dart';

Widget checkboxWidget (String name, bool value, int index, Function onChange) {
  bool checkboxValue = value;

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
        Transform.scale(
            scale: 1.75,
            child: Checkbox(
              value: checkboxValue,
              onChanged: (boolValue) => onChange(index, boolValue),
              checkColor: Constants.darkAccent,
              activeColor: Constants.darkBG,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
        )
      ],
    )
  );
}