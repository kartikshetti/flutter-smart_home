import 'package:flutter/material.dart';
import 'package:smart_home/device.dart';
import 'package:smart_home/device_tile.dart';
import 'package:smart_home/main_route.dart';
class First extends StatelessWidget {
  BuildContext Context;

  final _devices = <Device>[];
  static const _deviceNames = <String>[
    'Power Strip(WiFi)',
    'Switch(ZigBee)',
    'Lighting(Wi-Fi)',
    'Lighting(Bluetooth)',
    'Gateway(Bluetooth)',
    'Socket(Wi-Fi)',
    'Smart Cam',
    'Motion detector',
  ];
  static const icons =<String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',];

  void _navigateToAddNewDevices(BuildContext context){

    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(

          body: MainRoute(

          ),
        );
      },
    ));
  }

  void _onDeviceTap(Device device){
    print(device.name+" was tapped");
    _navigateToAddNewDevices(Context);

  }

  void buildDevicesList() {
    for (var i = 0; i < _deviceNames.length; i++) {
      _devices.add(Device(
        name: _deviceNames[i],
        iconLocation: icons[i],
        isDeviceRunning: false,
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    //Construct the device list for the first build only
    if(_devices.length == 0)
           buildDevicesList();
    Context = context;
    var gridview =  GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: _devices.map((Device device) {
        return DeviceTile(
          device: device,
          onTap: _onDeviceTap,
        );
      }).toList(),
    );
    //Creates a list view of the Categories
    /**final listView = Padding(
        padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 48.0
        ),
        child: gridview
    );**/

    return Scaffold(
        body: Container(
        // Sets the padding in the main container
        padding: const EdgeInsets.only(bottom: 2.0),
    child: gridview,
    ));

  }
}