
import 'package:flutter/material.dart';
import 'device.dart';
import 'device_tile.dart';
import 'add_new_device_route.dart';
class MainRoute extends StatefulWidget{

  @override
  _MainRouteState createState() => _MainRouteState();

}

class _MainRouteState extends State<MainRoute> with SingleTickerProviderStateMixin{
  //Tabcontroller for bottom navbar
  //TabController controller;

  Device _currentDevice;
  final _devices = <Device>[];
  bool isDeviceListEmpty = true;


  @override
  void initState() {
    super.initState();
    //controller = TabController(length: 3,vsync: this);
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }



  void _addDevices(Device device){
    setState(() {
      isDeviceListEmpty = false;
      _devices.add(device);
    });
  }

    void _onDeviceTap(Device device){
        setState(() {
          _currentDevice = device;
        });
    }

    void _navigateToAddNewDevices(BuildContext context){

        Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Scaffold(

              body: AddNewDeviceRoute(

              ),
            );
          },
        ));
      }


    Widget _buildDeviceWidgets(bool isDeviceListEmpty) {
      if (isDeviceListEmpty) {
        var column=
        Column(
          children: [Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/no_devices.png'),
          ),
              Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
              'No connected devices, Please add a device'
            )),

      RaisedButton(
      child: Text('Add Device'),
      onPressed: () => _navigateToAddNewDevices(context),
      textColor: Colors.white,
      color: Colors.blue,
      splashColor: Colors.blue[300],
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.blue)
      ),
      padding: const EdgeInsets.all(8.0),

      )]);
        return Center(
          child: Container(
              height: 240,
            child: Align(
              alignment: Alignment.center,
              child: column
              ),
            ),
          );
      }
      else {
        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          children: _devices.map((Device device) {
            return DeviceTile(
              device: device,
              onTap: _onDeviceTap,
            );
          }).toList(),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0
      ),
        child:_buildDeviceWidgets(isDeviceListEmpty)
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Smart Home',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
    /**final tabBar =TabBarView(
      // Add tabs as widgets
      children: <Widget>[FirstTab(), SecondTab(), ThirdTab()],
      // set the controller
      controller: controller,
    );**/

    return Scaffold(
      appBar: appBar,
      body: listView,

      /**bottomNavigationBar:Material(
        color: Colors.blue,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              // set icon to the tab
              icon: Icon(Icons.favorite),
            ),
            Tab(
              icon: Icon(Icons.adb),
            ),
            Tab(
              icon: Icon(Icons.airport_shuttle),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),**/
    );
  }


}