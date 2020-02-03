import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

Map<String, dynamic> jsonTemplateSettings = {
  "currentCompetition" : "Ryerson"
};

class Settings {
  String currentCompetition;

  Settings({this.currentCompetition});

  Settings.fromJson(Map<String, dynamic> json) {
    currentCompetition = json['currentCompetition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentCompetition'] = this.currentCompetition;
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

void shareSettings() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String settingsPath = appDocPath + "/settings.json";

  Uint8List bytes1 = await File(settingsPath).readAsBytes();

  await Share.file("Share Match Data", "Settings", bytes1, '*/*');
}

void saveSettings(String value) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String settingsPath = appDocPath + "/settings.json";

  Map<String, dynamic> currentSettings = await getSettings();
  Settings newSettings = Settings.fromJson(currentSettings);
  newSettings.currentCompetition = value;
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