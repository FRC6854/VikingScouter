import 'package:flutter/material.dart';

Widget numberWidget (String name, int value, int index, Function onChange) {
  return Container(
    margin: EdgeInsets.only(left: 50, right: 50),
    child: Column(
      children: <Widget>[
        Text(name),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        TextField(
          decoration: new InputDecoration(labelText: "Enter number"),
          keyboardType: TextInputType.number,
          onSubmitted: (number) => onChange(index, int.parse(number)),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
      ],
    )
  );
}