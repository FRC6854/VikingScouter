import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viking_scouter/models/settings.dart';
import 'package:viking_scouter/models/tableau_output.dart';
import 'package:viking_scouter/util/constants.dart';
import 'package:viking_scouter/models/items.dart';
import 'package:viking_scouter/templates/counter.dart';
import 'package:viking_scouter/templates/number.dart';
import 'package:viking_scouter/templates/note.dart';
import 'package:viking_scouter/templates/checkbox.dart';
import 'package:viking_scouter/templates/header.dart';

import 'package:viking_scouter/templates/match-number.dart';
import 'package:viking_scouter/templates/team-number.dart';

JSONData jsonData = JSONData.fromJson(jsonTemplateItems);
BuildContext mainContext;

class MatchDataInputPage extends StatefulWidget {
  MatchDataInputPage(JSONData data) {
    if (data == null) {
      jsonData = JSONData.fromJson(jsonTemplateItems);
    }
    else {
      jsonData = data;
    }
  }

  @override
  _MatchDataInputPageState createState() => _MatchDataInputPageState();
}

class _MatchDataInputPageState extends State<MatchDataInputPage> {
  @override
  Widget build(BuildContext context) {
    mainContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("6854 Dynamic Scouting App", style: TextStyle(
            color: Constants.lightPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Aileron'
        )),
        backgroundColor: Constants.darkPrimary,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => showSaveDialog(),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              //Divider(height: 20, color: Constants.darkAccent, indent: 5, endIndent: 5,),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: jsonData.items.length,
                  itemBuilder: (context, index) {
                    if(jsonData.items[index].type == "counter") {
                      return counterWidget(jsonData.items[index].name, jsonData.items[index].value, index, onPushCounter);
                    }
                    else if(jsonData.items[index].type == "number") {
                      return numberWidget(jsonData.items[index].name, jsonData.items[index].value, index, onChangeNumber);
                    }
                    else if(jsonData.items[index].type == "checkbox") {
                      return checkboxWidget(jsonData.items[index].name, jsonData.items[index].value, index, onChangeCheckbox);
                    }
                    else if(jsonData.items[index].type == "header") {
                      return headerWidget(jsonData.items[index].name, index);
                    }
                    else if(jsonData.items[index].type == "note") {
                      return noteWidget(jsonData.items[index].name, jsonData.items[index].value, index, onChangeNote);
                    }
                    else if(jsonData.items[index].type == "match-number") {
                      return matchNumberWidget("Match Number", jsonData.match.matchNumber, onChangeMatchNumber);
                    }
                    else if(jsonData.items[index].type == "team-number") {
                      return teamNumberWidget("Team Number", jsonData.match.teamNumber, onChangeTeamNumber);
                    }
                    else {
                      return Text("Error parsing JSON, invalid type of Widget in ${jsonData.items[index].name} of type: ${jsonData.items[index].type}");
                    }
                  },
                ),
              )
            ],
          )
        ),
      )
    );
  }

  void onPushCounter(int index, int multiplier) {
    setState(() {
      jsonData.items[index].value = jsonData.items[index].value + (1 * multiplier);
    });
  }

  void onChangeNumber(int index, int value) {
    jsonData.items[index].value = value;
  }

  void onChangeMatchNumber(int value) {
    jsonData.match.matchNumber = value;
  }

  void onChangeTeamNumber(int value) {
    jsonData.match.teamNumber = value;
  }

  void onChangeCheckbox(int index, bool value) {
    setState(() {
      jsonData.items[index].value = value;
    });
  }

  void onChangeNote(int index, String value) {
    jsonData.items[index].value = value;
  }

  void showSaveDialog() async {
    Map<String, dynamic> settings = await getSettings();
    jsonData.match.competition = Settings.fromJson(settings).currentCompetition;

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning", style: TextStyle(color: Constants.darkBG)),
          content: new Text("Are you sure you want to continue?", style: TextStyle(color: Constants.darkBG)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SAVE", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                saveDataToFiles();
                Navigator.of(context).pop();
                Navigator.of(mainContext).pop();
              }
            ),
          ],
          backgroundColor: Constants.darkAccent,
        );
      },
    );
  }

  void saveDataToFiles() async {
    saveData(jsonData);

    Settings settings = Settings.fromJson(await getSettings());

    TableauOutput tableauOutputFile = new TableauOutput();
    tableauOutputFile.team = jsonData.match.teamNumber;
    tableauOutputFile.match = jsonData.match.matchNumber;
    tableauOutputFile.scout = settings.scoutID;
    tableauOutputFile.time = new DateTime.now().millisecondsSinceEpoch;
    tableauOutputFile.metrics = new Metrics();
    tableauOutputFile.metrics.values = new Map<String, dynamic>();

    Map<String, dynamic> matchDataItems = new Map<String, dynamic>();
    for (int i = 0; i < jsonData.items.length; i++) {
      if (jsonData.items[i].type != "header") {
        matchDataItems[jsonData.items[i].name] = jsonData.items[i].value;
      }
    }
    tableauOutputFile.metrics.values = matchDataItems;

    saveTableauData(tableauOutputFile);
  }
}