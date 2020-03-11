import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:viking_scouter/models/settings.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:share_extend/share_extend.dart';
import 'package:viking_scouter/util/constants.dart';
import 'package:viking_scouter/models/tableau_output.dart';

Map<String, dynamic> jsonTemplateItems = {
  "match": {
    "competition": "",
    "matchNumber": 0,
    "teamNumber": 0
  },

  "items": [
    {
      "name": "Match",
      "type": "header",
      "value": 0
    },
    {
      "name": "Match Number",
      "type": "match-number",
      "value": 0
    },
    {
      "name": "Team Number",
      "type": "team-number",
      "value": 0
    },
    {
      "name": "Autonomous",
      "type": "header",
      "value": 0
    },
    {
      "name": "Autoline Crossed",
      "type": "checkbox",
      "value": false
    },
    {
      "name": "Auto High Goal",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Auto Low Goal",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Teleop",
      "type": "header",
      "value": 0
    },
    {
      "name": "Teleop High Goal",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Teleop Low Goal",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Endgame",
      "type": "header",
      "value": 0
    },
    {
      "name": "Climb?",
      "type": "checkbox",
      "value": false
    },
    {
      "name": "Balanced?",
      "type": "checkbox",
      "value": false
    },
    {
      "name": "Notes",
      "type": "note",
      "value": ""
    },
  ]
};

class JSONData {
  Match match;
  List<Items> items;

  JSONData({this.match, this.items});

  JSONData.fromJson(Map<String, dynamic> json) {
    match = json['match'] != null ? new Match.fromJson(json['match']) : null;
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.match != null) {
      data['match'] = this.match.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Match {
  String competition;
  int matchNumber;
  int teamNumber;

  Match({this.competition, this.matchNumber, this.teamNumber});

  Match.fromJson(Map<String, dynamic> json) {
    competition = json['competition'];
    matchNumber = json['matchNumber'];
    teamNumber = json['teamNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['competition'] = this.competition;
    data['matchNumber'] = this.matchNumber;
    data['teamNumber'] = this.teamNumber;
    return data;
  }
}

class Items {
  String name;
  String type;
  var value;

  Items({this.name, this.type, this.value});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

void createMatchesFolder() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  Directory matchesDir = new Directory(appDocPath + "/matches/");
  if (await matchesDir.exists() == false) {
    await matchesDir.create(recursive: true);
  }
}

void createTableauFolder() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  Directory matchesDir = new Directory(appDocPath + "/tableau/");
  if (await matchesDir.exists() == false) {
    await matchesDir.create(recursive: true);
  }
}

void saveData(JSONData data) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  Settings settings = Settings.fromJson(await getSettings());

  // e.g. /matches/Western-33-6854-22.json
  String dataPath = appDocPath + "/matches/" + data.match.competition + "-" + data.match.matchNumber.toString() + "-" + data.match.teamNumber.toString() + "-" + settings.scoutID.toString() + ".json";

  new File(dataPath).writeAsString(json.encode(data.toJson()));
}

void saveTableauData(TableauOutput data) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  Settings settings = Settings.fromJson(await getSettings());

  // e.g. /matches/Western-33-6854-22.json
  String tableauPath = appDocPath + "/tableau/" + settings.currentCompetition + "-" + data.match.toString() + "-" + data.team.toString() + "-" + data.scout.toString() + ".json";

  new File(tableauPath).writeAsString(json.encode(data.toJson()));
}

/*
  Fetch data for main menu
 */

Future<List<Map<String, dynamic>>> getDataLists() async {
  List<Map<String, dynamic>> dataLists = new List<Map<String, dynamic>>();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory matchesDir = new Directory(appDocDir.path + "/matches/");

  for (File file in matchesDir.listSync()) {
    await file.readAsString().then((String contents) {
      dataLists.add(json.decode(contents));
    });
  }

  return dataLists;
}

/*
  SHARE FILES
 */

void shareFileFromIndex(int index) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory matchesDir = new Directory(appDocDir.path + "/matches/");

  for (int i = 0; i < matchesDir.listSync().length; i++) {
    if (i == index) {
      String path = matchesDir.listSync()[i].path;

      String pathContents = await new File(path).readAsString();

      JSONData matchData = JSONData.fromJson(json.decode(pathContents));
      Settings settings = Settings.fromJson(await getSettings());

      TableauOutput tableauOutputFile = new TableauOutput();
      tableauOutputFile.team = matchData.match.teamNumber;
      tableauOutputFile.match = matchData.match.matchNumber;
      tableauOutputFile.scout = settings.scoutID;
      tableauOutputFile.time = new DateTime.now().millisecondsSinceEpoch;
      tableauOutputFile.metrics = new Metrics();
      tableauOutputFile.metrics.values = new Map<String, dynamic>();

      Map<String, dynamic> matchDataItems = new Map<String, dynamic>();
      for (int i = 0; i < matchData.items.length; i++) {
        if (matchData.items[i].type != "header" && matchData.items[i].type != "match-number" && matchData.items[i].type != "team-number") {
          matchDataItems[matchData.items[i].name] = matchData.items[i].value;
        }
      }
      tableauOutputFile.metrics.values = matchDataItems;

      ShareExtend.share(json.encode(tableauOutputFile.toJson()), "text");
    }
  }
}

Future getDataListFiles() async {
  List<String> files = new List<String>();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory matchesDir = new Directory(appDocDir.path + "/matches/");

  for (File file in matchesDir.listSync()) {
    files.add(file.path);
  }

  return files;
}

Future getTableauDataFiles() async {
  List<String> files = new List<String>();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory matchesDir = new Directory(appDocDir.path + "/tableau/");

  for (File file in matchesDir.listSync()) {
    files.add(file.path);
  }

  return files;
}

/*
  BLUETOOTH SERIAL FILE SENDING
 */

void sendAllTableauFiles(BuildContext context) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory tableauDir = new Directory(appDocDir.path + "/tableau/");
  Settings settings = Settings.fromJson(await getSettings());

  try {
    BluetoothConnection connection = await BluetoothConnection.toAddress(settings.bluetoothDevice);
    print('Connected to the device');

    for (int i = 0; i < tableauDir.listSync().length; i++) {
      String path = tableauDir.listSync()[i].path;
      connection.output.add(new File(path).readAsBytesSync());
    }

    print('Done sending files');

    connection.dispose();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success", style: TextStyle(color: Constants.darkBG)),
          content: new Text("Successfully send the data to the Bluetooth Hub", style: TextStyle(color: Constants.darkBG)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Constants.darkAccent,
        );
      },
    );
  }
  catch (exception) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error", style: TextStyle(color: Constants.darkBG)),
          content: new Text("Cannot connect, exception occured", style: TextStyle(color: Constants.darkBG)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("RETRY", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                Navigator.of(context).pop();
                sendAllTableauFiles(context);
              },
            ),
          ],
          backgroundColor: Constants.darkAccent,
        );
      },
    );
    print(exception);
    print('Cannot connect, exception occured');
  }
}

void sendTableauFileFromIndex(int index, BuildContext context) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory tableauDir = new Directory(appDocDir.path + "/tableau/");

  for (int i = 0; i < tableauDir.listSync().length; i++) {
    if (i == index) {
      Settings settings = Settings.fromJson(await getSettings());
      String path = tableauDir.listSync()[i].path;

      print(path);
      print(settings.bluetoothDevice);

      try {
        BluetoothConnection connection = await BluetoothConnection.toAddress(settings.bluetoothDevice);
        print('Connected to the device');

        connection.output.add(new File(path).readAsBytesSync());

        print('Done sending file');

        connection.dispose();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Success", style: TextStyle(color: Constants.darkBG)),
              content: new Text("Successfully send the data to the Bluetooth Hub", style: TextStyle(color: Constants.darkBG)),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("CLOSE", style: TextStyle(color: Constants.darkBG)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              backgroundColor: Constants.darkAccent,
            );
          },
        );
      }
      catch (exception) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Error", style: TextStyle(color: Constants.darkBG)),
              content: new Text("Cannot connect, exception occured", style: TextStyle(color: Constants.darkBG)),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("CLOSE", style: TextStyle(color: Constants.darkBG)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("RETRY", style: TextStyle(color: Constants.darkBG)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    sendAllTableauFiles(context);
                  },
                ),
              ],
              backgroundColor: Constants.darkAccent,
            );
          },
        );
        print(exception);
        print('Cannot connect, exception occured');
      }
    }
  }
}