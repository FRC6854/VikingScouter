import 'package:flutter/material.dart';
import 'models/items.dart';
import 'templates/counter.dart';
import 'templates/number.dart';
import 'templates/checkbox.dart';
import 'util/constants.dart';

void main() => runApp(MyApp());

ItemsList items = ItemsList.fromJson(json);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Constants.darkTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Divider(height: 20, color: Constants.darkAccent, indent: 5, endIndent: 5,),
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
                  },
                ),
              ),
              
              RaisedButton(
                child: Text("Done"), 
                onPressed: () => printData(),
                color: Constants.darkAccent,
                textColor: Constants.darkBG,
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

  void printData(){
    print(items.toJson());
  }
}


