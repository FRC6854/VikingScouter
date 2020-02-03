import 'package:flutter/material.dart';
import 'package:viking_scouter/models/items.dart';
import 'package:viking_scouter/pages/matchDataInput.dart';
import 'package:viking_scouter/util/constants.dart';
import 'package:viking_scouter/models/settings.dart';
import 'package:permission_handler/permission_handler.dart';

var currentCompetitionValue;
List<JSONData> dataLists = new List<JSONData>();

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    setup();
    return Scaffold(
        appBar: AppBar(
          title: Text("6854 Dynamic Scouting App", style: TextStyle(
              color: Constants.darkPrimary,
              fontSize: 25,
              fontWeight: FontWeight.w500,
              fontFamily: 'Aileron'
          )),
          backgroundColor: Constants.lightPrimary,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () => _showDialog(),
        ),
        body: Center(
          child: Container(
              child: Column(
                children: <Widget>[
                  listOfDataWidget(),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  RaisedButton(
                    child: Text("New Match"),
                    color: Constants.lightPrimary,
                    textColor: Constants.darkBG,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MatchDataInputPage(null)),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                  )
                ],
              )
          ),
        )
    );
  }

  Future loadDataLists() async {
    List<Map<String, dynamic>> tempDataList = await getDataLists();
    setState(() {
      dataLists.clear();
    });
    for (Map<String, dynamic> map in tempDataList) {
      dataLists.add(JSONData.fromJson(map));
    }
  }

  Widget listOfDataWidget() {
    return Expanded(
        child: Container(
            child: ListView.builder(
                itemCount: dataLists.length,
                itemBuilder: (context, index) {
                  JSONData currentDataList = dataLists[index];
                  return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.flag),
                            title: Text(currentDataList.match.competition.toString() + " - " + currentDataList.match.matchNumber.toString()),
                            subtitle: Text("Team Number - " + currentDataList.match.teamNumber.toString()),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('EDIT'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MatchDataInputPage(currentDataList)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                  );
                }
            )
        )
    );
  }

  void setup() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      bool isOpened = await PermissionHandler().openAppSettings();
    }

    createMatchesFolder();
    checkSettingsFile();
    await loadDataLists();
    Map<String, dynamic> settings = await getSettings();
    currentCompetitionValue = new TextEditingController(text: Settings.fromJson(settings).currentCompetition);
  }

  void _showDialog() async {
    await showDialog<String>(
      context: context,
      // ignore: deprecated_member_use
      child: new AlertDialog(
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                controller: currentCompetitionValue,
                decoration: new InputDecoration(
                  labelText: "Enter current competition",
                  hintText: "e.g. Western",
                  labelStyle: TextStyle(
                      color: Constants.darkBG
                  ),
                  hintStyle: TextStyle(
                      color: Constants.darkPrimary
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none
                      )
                  )
                ),
                style: TextStyle(
                  color: Constants.darkBG
                ),
                onChanged: (text) {
                  saveSettings(text);
                },
                cursorColor: Constants.darkBG,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text(
                'CANCEL',
                style: TextStyle(
                    color: Constants.darkBG
                )
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
            child: new Text(
                'SAVE',
                style: TextStyle(
                    color: Constants.darkBG
                )
            ),
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
        backgroundColor: Constants.darkAccent,
      ),
    );
  }
}