import 'package:flutter/material.dart';
import 'package:dynamic_scouting_app/util/constants.dart';
import 'package:dynamic_scouting_app/models/items.dart';
import 'package:dynamic_scouting_app/templates/counter.dart';
import 'package:dynamic_scouting_app/templates//number.dart';
import 'package:dynamic_scouting_app/templates/checkbox.dart';
import 'package:dynamic_scouting_app/templates/header.dart';

ItemsList items = ItemsList.fromJson(json);

class MatchDataInputPage extends StatefulWidget {
  @override
  _MatchDataInputPageState createState() => _MatchDataInputPageState();
}

class _MatchDataInputPageState extends State<MatchDataInputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("6854 Dynamic Scouting App", style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          fontFamily: 'Aileron',
          )),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => _showDialog(),
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
                  itemCount: items.items.length,
                  itemBuilder: (context, index) {
                    if(items.items[index].type == "counter") {
                      return counterWidget(items.items[index].name, items.items[index].value, index, onPushCounter);
                    }
                    if(items.items[index].type == "number") {
                      return numberWidget(items.items[index].name, items.items[index].value, index, onChangeNumber);
                    }
                    if(items.items[index].type == "checkbox") {
                      return checkboxWidget(items.items[index].name, items.items[index].value, index, onChangeCheckbox);
                    }
                    if(items.items[index].type == "header") {
                      return headerWidget(items.items[index].name, index);
                    }

                    return Text("Error parsing JSON, invalid type of Widget in ${items.items[index].name} of type: ${items.items[index].type}");
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
      items.items[index].value = items.items[index].value + (1 * multiplier);
    });
  }

  void onChangeNumber(int index, int value) {
    items.items[index].value = value;
  }

  void onChangeCheckbox(int index, bool value) {
    setState(() {
      if(value == false)
        items.items[index].value = 0;
      if(value == true)
        items.items[index].value = 1;
    });
  }

  void _showDialog() {
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
              child: new Text("Continue", style: TextStyle(color: Constants.darkBG)),
              onPressed: () {
                printData();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(color: Constants.darkBG)),
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

  void printData(){
    print(items.toJson());
  }
}