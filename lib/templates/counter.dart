import 'package:flutter/material.dart';

Widget counterWidget (String name, int value, int index, Function onPushMethod) {
  return Container(
    margin: EdgeInsets.only(left: 50, right: 50),
    child: Column(
      children: <Widget>[
        Text(name),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: () => onPushMethod(index, 1),
            ),
            Text(value.toString()),
            RaisedButton(
              child: Icon(Icons.remove),
              onPressed: () => onPushMethod(index, -1),
            ),
          ],
        )
      ],
    )
  );
}