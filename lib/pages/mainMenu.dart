import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

import 'package:viking_scouter/models/items.dart';
import 'package:viking_scouter/pages/bluetooth.dart';
import 'package:viking_scouter/pages/matchDataInput.dart';
import 'package:viking_scouter/util/constants.dart';
import 'package:viking_scouter/models/settings.dart';

import 'package:permission_handler/permission_handler.dart';

TextEditingController currentCompetitionValue = new TextEditingController();
TextEditingController currentScoutIDValue = new TextEditingController();

List<JSONData> dataLists = new List<JSONData>();

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    update();
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                    'Settings',
                    style: TextStyle(
                        color: Constants.lightPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Aileron'
                    )
                ),
                decoration: BoxDecoration(
                  color: Constants.darkBG,
                ),
              ),
              ExpansionTile(
                title: Text("Current Competition"),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
                    child: TextField(
                      controller: currentCompetitionValue,
                      decoration: new InputDecoration(
                          hintText: "e.g. Western",
                          labelStyle: TextStyle(
                              color: Constants.lightPrimary
                          ),
                          hintStyle: TextStyle(
                              color: Constants.lightPrimary
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  style: BorderStyle.none
                              )
                          )
                      ),
                      style: TextStyle(
                          color: Constants.lightPrimary
                      ),
                      onChanged: (text) {
                        updateSettingsCurrentCompetition(text);
                        saveSettings();
                      },
                      cursorColor: Constants.lightPrimary,
                    )
                  )
                ]
              ),
              ExpansionTile(
                  title: Text("Scout ID"),
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        child: TextField(
                          controller: currentScoutIDValue,
                          decoration: new InputDecoration(
                              hintText: "e.g. 21",
                              labelStyle: TextStyle(
                                  color: Constants.lightPrimary
                              ),
                              hintStyle: TextStyle(
                                  color: Constants.lightPrimary
                              ),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      style: BorderStyle.none
                                  )
                              )
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Constants.lightPrimary
                          ),
                          onChanged: (value) {
                            updateSettingsScoutID(int.parse(value));
                            saveSettings();
                          },
                          cursorColor: Constants.lightPrimary,
                        )
                    )
                  ]
              ),
              ExpansionTile(
                title: Text("Bluetooth Settings"),
                children: <Widget>[
                  ListTile(
                    title: Text("Send All Match Data"),
                    onTap: () {
                      sendAllTableauFiles(context);
                    },
                  ),
                  ListTile(
                    title: Text("Bluetooth"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BluetoothPage()),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text("Share All Match Data"),
                onTap: () {
                  shareAll();
                },
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchDataInputPage(null)),
          )
        ),
        body: Center(
          child: Container(
              child: Column(
                children: <Widget>[
                  listOfDataWidget()
                ],
              )
          ),
        )
    );
  }

  Widget listOfDataWidget() {
    if (dataLists.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text(
          "No Match Data Yet...",
          style: TextStyle(
              color: Constants.lightPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w300,
              fontFamily: 'Aileron'
          ),
        ),
      );
    }
    return Expanded(
        child: Container(
            child: Padding(
              padding: EdgeInsets.all(5),
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
                                child: const Text('SHARE'),
                                onPressed: () {
                                  shareFileFromIndex(index);
                                },
                              ),
                              FlatButton(
                                child: const Text('SEND'),
                                onPressed: () {
                                  sendTableauFileFromIndex(index, context);
                                },
                              ),
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
              ),
            )
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

  void shareAll() async {
    List<String> shares = await getTableauDataFiles();

    if (shares.length == 0) {
      return;
    }

    ShareExtend.shareMultiple(shares, "files");
  }

  void update() async {
    await loadDataLists();

    Map<String, dynamic> settings = await getSettings();

    String newValueCurrentCompetition = Settings.fromJson(settings).currentCompetition;
    String newValueScoutID = Settings.fromJson(settings).scoutID.toString();

    currentCompetitionValue.value = TextEditingValue(
      text: newValueCurrentCompetition
    );

    currentScoutIDValue.value = TextEditingValue(
      text: newValueScoutID
    );
  }

  void setup() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }

    createMatchesFolder();
    createTableauFolder();
    checkSettingsFile();

    await loadDataLists();
  }
}