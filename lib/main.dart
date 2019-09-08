import 'package:flutter/material.dart';
import 'util/constants.dart';
import 'pages/matchDataInput.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Constants.darkTheme,
      home: MatchDataInputPage(),
    );
  }
}


