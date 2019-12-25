

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tabs/bluetooth_tab.dart';
import 'tabs/wifi_tab.dart';
class AddNewDeviceRoute extends StatefulWidget {

  @override
  _AddNewDeviceRoute createState() => _AddNewDeviceRoute();
}

class _AddNewDeviceRoute extends State<AddNewDeviceRoute> with SingleTickerProviderStateMixin{
  TabController controller;


  /**
   *
   *   final _devices = <Device>[];
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




 void _onDeviceTap(Device device){
   print('I was tapped');
 }

      */
  @override
  void initState() {
    super.initState();
    /**for (var i = 0; i < _deviceNames.length; i++) {
      _devices.add(Device(
        name: _deviceNames[i],
        iconLocation: icons[i],
        isDeviceRunning: false,
      ));
    }**/
    // Initialize the Tab Controller
    controller = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
   //Dispose of the controller
   controller.dispose();
    super.dispose();

  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          // set icon to the tab
          icon: Icon(Icons.bluetooth),
        ),
        Tab(
          icon: Icon(Icons.wifi),
        ),
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }




  @override
  Widget build(BuildContext context) {
    /**var gridview =  GridView.count(
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
    final listView = Padding(
      padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0
      ),
      child: gridview
    );**/

    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text(
            " New Device",
          ),
          bottom: getTabBar(),
        ),
      //Set TabBarView as body of scaffold
      body: getTabBarView(<Widget>[First(), Second()]));
      /**body: Container(
        // Sets the padding in the main container
        padding: const EdgeInsets.only(bottom: 2.0),
        child: gridview,
      ),**/
  }
}
