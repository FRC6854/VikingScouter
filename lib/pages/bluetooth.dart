import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viking_scouter/models/settings.dart';
import 'package:viking_scouter/templates/bluetoothDeviceListEntry.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {

  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  @override
  void initState() {
    super.initState();

    isDiscovering = true;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() { results.add(r); });
    });

    _streamSubscription.onDone(() {
      setState(() { isDiscovering = false; });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering ? Text('Discovering Devices') : Text('Discovered Devices'),
        actions: <Widget>[
          (
            isDiscovering ?
              FittedBox(child: Container(
                margin: new EdgeInsets.all(16.0),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              ))
            :
              IconButton(
                icon: Icon(Icons.replay),
                onPressed: _restartDiscovery
              )
          )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
              device: result.device,
              rssi: result.rssi,
              onTap: () {
                updateBluetoothDevice(result.device.address);
                saveSettings();
                Navigator.of(context).pop();
              },
              onLongPress: () async {
                try {
                  bool bonded = false;
                  if (result.device.isBonded) {
                    print('Unbonding from ${result.device.address}...');
                    await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(result.device.address);
                    print('Unbonding from ${result.device.address} has succed');
                  }
                  else {
                    print('Bonding with ${result.device.address}...');
                    bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(result.device.address);
                    print('Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
                  }
                  setState(() {
                    results[results.indexOf(result)] = BluetoothDiscoveryResult(
                        device: BluetoothDevice(
                          name: result.device.name ?? '',
                          address: result.device.address,
                          type: result.device.type,
                          bondState: bonded ? BluetoothBondState.bonded : BluetoothBondState.none,
                        ),
                        rssi: result.rssi
                    );
                  });
                }
                catch (ex) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error occured while bonding'),
                        content: Text("${ex.toString()}"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
          );
        },
      )
    );
  }
}