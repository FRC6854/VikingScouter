import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';

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
            Container(
              child: RaisedButton(
                child: Icon(Icons.add),
                onPressed: () => onPushMethod(index, 1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Constants.darkAccent,
                textColor: Constants.darkBG,
              ),
            ),
            Text(value.toString()),
            Container(
              child: RaisedButton(
                child: Icon(Icons.remove),
                onPressed: () => onPushMethod(index, -1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Constants.darkAccent,
                textColor: Constants.darkBG,
              ),
            ),
          ],
        )
      ],
    )
  );
}