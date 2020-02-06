import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Map<String, dynamic> jsonTemplateSettings = {
  "currentCompetition" : "Ryerson",
  "scoutID" : 212,
  "bluetoothDevice" : ""
};

String lastCurrentCompetition;
int lastScoutID;
String lastBluetoothDevice;

class Settings {
  String currentCompetition;
  int scoutID;
  String bluetoothDevice;

  Settings({this.currentCompetition, this.scoutID, this.bluetoothDevice});

  Settings.fromJson(Map<String, dynamic> json) {
    currentCompetition = json['currentCompetition'];
    scoutID = json['scoutID'];
    bluetoothDevice = json['bluetoothDevice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentCompetition'] = this.currentCompetition;
    data['scoutID'] = this.scoutID;
    data['bluetoothDevice'] = this.bluetoothDevice;
    return data;
  }
}

void checkSettingsFile() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String settingsPath = appDocPath + "/settings.json";

  if (FileSystemEntity.typeSync(settingsPath) == FileSystemEntityType.notFound) {
    print("Not found");
    new File(settingsPath).writeAsString(json.encode(jsonTemplateSettings));
  }
}

void updateSettingsCurrentCompetition(String value) {
  lastCurrentCompetition = value;
}

void updateSettingsScoutID(int value) {
  lastScoutID = value;
}

void updateBluetoothDevice(String value) {
  lastBluetoothDevice = value;
}

void saveSettings() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String settingsPath = appDocPath + "/settings.json";

  Map<String, dynamic> currentSettings = await getSettings();
  Settings newSettings = Settings.fromJson(currentSettings);
  print(newSettings.scoutID);
  newSettings.currentCompetition = lastCurrentCompetition;
  newSettings.scoutID = lastScoutID;
  newSettings.bluetoothDevice = lastBluetoothDevice;
  new File(settingsPath).writeAsString(json.encode(newSettings.toJson()));
}

Future<Map<String, dynamic>> getSettings() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String settingsPath = appDocPath + "/settings.json";

  String jsonToDecode;
  await new File(settingsPath).readAsString().then((String contents) => jsonToDecode = contents);
  return json.decode(jsonToDecode);
}