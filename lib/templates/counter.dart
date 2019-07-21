import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';

Widget counterWidget (String name, int value, int index, Function onPushMethod) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: RaisedButton(
                child: Icon(Icons.add, color: Constants.darkAccent),
                onPressed: () => onPushMethod(index, 1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0), side: BorderSide(color: Constants.darkAccent)),
                color: Colors.transparent,
                textColor: Constants.darkBG,
                splashColor: Constants.darkAccent,
              ),
            ),
            Text(value.toString(), style: TextStyle(
              fontFamily: "Open Sans",
              fontWeight: FontWeight.w300,
              fontSize: 20.0
            )),
            Container(
              child: RaisedButton(
                child: Icon(Icons.remove, color: Constants.darkAccent),
                onPressed: () => onPushMethod(index, -1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0), side: BorderSide(color: Constants.darkAccent)),
                color: Colors.transparent,
                textColor: Constants.darkBG,
                splashColor: Constants.darkAccent,
              ),
            ),
          ],
        )
      ],
    )
  );
}