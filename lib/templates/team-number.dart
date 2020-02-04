import 'package:flutter/material.dart';
import 'package:viking_scouter/util/constants.dart';

Widget teamNumberWidget (String name, int value,  Function onChange) {
  var controller = new TextEditingController(text: value.toString());

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
          controller: controller,
          decoration: new InputDecoration(
              labelText: "Enter number",
              labelStyle: TextStyle(
                  fontFamily: "Open Sans",
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                  color: Constants.darkAccent
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none
                  )
              )
          ),
          keyboardType: TextInputType.number,
          onChanged: (number) => onChange(int.parse(number)),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
      ],
    )
  );
}