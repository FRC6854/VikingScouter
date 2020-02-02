import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
      "name": "Sandstorm",
      "type": "header",
      "value": 0
    },
    {
      "name": "Cargo Ship Hatch Panels Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Demo Note",
      "type": "note",
      "value": ""
    },
    {
      "name": "Cargo Ship Cargo Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Hatch Panels Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Cargo Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Autoline Crossed",
      "type": "checkbox",
      "value": false
    },
    {
      "name": "Teleop",
      "type": "header",
      "value": 0
    },
    {
      "name": "Cargo Ship Hatch Panels",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Cargo Ship Cargo",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Hatch Panels",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Cargo",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Endgame",
      "type": "header",
      "value": 0
    },
    {
      "name": "Total RP",
      "type": "number",
      "value": 0
    },
    {
      "name": "Total Points for Team",
      "type": "number",
      "value": 0
    },
    {
      "name": "Level of Climb",
      "type": "number",
      "value": 0
    }
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

  new Directory(appDocPath + "/matches/").create(recursive: true);
}

void saveData(JSONData data) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  // e.g. /matches/Western-33-6854.json
  String settingsPath = appDocPath + "/matches/" + data.match.competition + "-" + data.match.matchNumber.toString() + "-" + data.match.teamNumber.toString() + ".json";

  new File(settingsPath).writeAsString(json.encode(data.toJson()));
}

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